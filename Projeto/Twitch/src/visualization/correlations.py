import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
from pathlib import Path
from scipy.stats import f_oneway
from scipy.stats import chi2_contingency
import matplotlib.patheffects as pe
import powerlaw
from mpl_toolkits.mplot3d import Axes3D

def calculate_correlations(df, country, output_dir, numeric_cols, categorical_cols):
    """
    Calcula diferentes tipos de correlações baseado no tipo de variáveis.
    
    Args:
        df (DataFrame): DataFrame com os dados
        country (str): País sendo analisado
        output_dir (Path): Diretório para salvar as imagens
        numeric_cols (list): Lista com os nomes das colunas numéricas
        categorical_cols (list): Lista com os nomes das colunas categóricas
    """
    # Dicionário para armazenar resultados
    correlations = {
        'pearson': None,
        'spearman': None,
        'eta': {},
        'cramer': {}
    }
    
    # 1. Correlação de Pearson (variáveis numéricas)
    correlations['pearson'] = df[numeric_cols].corr(method='pearson')
    
    # 2. Correlação de Spearman (variáveis numéricas, não assume linearidade)
    correlations['spearman'] = df[numeric_cols].corr(method='spearman')
    
    # 3. Correlação ETA (entre variáveis categóricas e numéricas)
    for cat_col in categorical_cols:
        for num_col in numeric_cols:
            try:
                # Verificar se há valores válidos
                if df[cat_col].isna().all() or df[num_col].isna().all():
                    continue
                    
                # Remover valores NA
                valid_data = df[[cat_col, num_col]].dropna()
                if len(valid_data) == 0:
                    continue
                
                categories = valid_data[cat_col].unique()
                if len(categories) <= 1:  # Precisa ter mais de uma categoria
                    continue
                
                # Calcular ETA
                categories_means = valid_data.groupby(cat_col, observed=True)[num_col].mean()
                grand_mean = valid_data[num_col].mean()
                
                numerator = sum(len(valid_data[valid_data[cat_col] == cat]) * 
                              (categories_means[cat] - grand_mean)**2 
                              for cat in categories)
                denominator = sum((valid_data[num_col] - grand_mean)**2)
                
                if denominator > 0:
                    eta = np.sqrt(numerator/denominator)
                    correlations['eta'][(cat_col, num_col)] = eta
            except Exception as e:
                print(f"Erro no cálculo ETA para {cat_col} e {num_col}: {str(e)}")
                continue
    
    # 5. V de Cramér e Coeficiente de Contingência de Pearson
    for cat1 in categorical_cols:
        for cat2 in categorical_cols:
            if cat1 < cat2:  # Evita calcular correlações duplicadas
                try:
                    # Criar tabela de contingência
                    contingency = pd.crosstab(df[cat1], df[cat2])
                    
                    # Calcular chi-quadrado
                    chi2, p_value, dof, expected = chi2_contingency(contingency)
                    
                    # Calcular V de Cramér
                    n = len(df)
                    min_dim = min(len(df[cat1].unique()), len(df[cat2].unique())) - 1
                    cramer_v = np.sqrt(chi2 / (n * min_dim)) if min_dim > 0 else 0
                    
                    # Calcular Coeficiente de Contingência de Pearson
                    pearson_c = np.sqrt(chi2 / (chi2 + n))
                    
                    correlations['cramer'][(cat1, cat2)] = {
                        'cramer_v': cramer_v,
                        'pearson_c': pearson_c,
                        'p_value': p_value
                    }
                    
                except Exception as e:
                    print(f"Erro no cálculo para {cat1} e {cat2}: {str(e)}")
                    continue
    
    # Criar visualizações
    plot_correlations(correlations, country, output_dir)
    
    return correlations


def plot_correlations(correlations, country, output_dir):
    """
    Cria visualizações estilizadas para as diferentes correlações.
    """
    # Configurar estilo geral
    plt.style.use('dark_background')
    
    # Criar pastas
    notebook3_dir = output_dir / 'NoteBook3'
    notebook3_dir.mkdir(exist_ok=True)
    
    pearson_dir = notebook3_dir / 'Pearson'
    spearman_dir = notebook3_dir / 'Spearman'
    eta_dir = notebook3_dir / 'ETA'
    cramer_dir = notebook3_dir / 'Cramer'
    
    for dir_path in [pearson_dir, spearman_dir, eta_dir, cramer_dir]:
        dir_path.mkdir(exist_ok=True)

    # Pearson e Spearman
    plt.figure(figsize=(15, 10))
    
    # Garantir que a diagonal é NaN
    pearson_matrix = correlations['pearson'].copy()
    spearman_matrix = correlations['spearman'].copy()
    np.fill_diagonal(pearson_matrix.values, np.nan)
    np.fill_diagonal(spearman_matrix.values, np.nan)
    
    # Criar máscaras para os triângulos
    mask_lower = np.triu(np.ones_like(pearson_matrix), k=1)
    mask_upper = np.tril(np.ones_like(spearman_matrix), k=-1)
    
    # Plot do triângulo inferior (Pearson)
    sns.heatmap(pearson_matrix,
                mask=mask_lower,
                annot=True,
                cmap='RdYlBu_r',
                vmin=-1,
                vmax=1,
                fmt='.2f',
                square=True,
                linewidths=1,
                cbar=True,
                cbar_kws={
                    "shrink": .8,
                    "label": "Coeficiente de Correlação",
                    "orientation": "vertical"
                },
                annot_kws={
                    "size": 8,
                    "color": "black"
                })
    
    # Plot do triângulo superior (Spearman)
    sns.heatmap(spearman_matrix,
                mask=mask_upper,
                annot=True,
                cmap='RdYlBu_r',
                vmin=-1,
                vmax=1,
                fmt='.2f',
                square=True,
                linewidths=1,
                cbar=False,
                annot_kws={
                    "size": 8,
                    "color": "black"
                })
    
    # Adicionar uma linha preta na diagonal
    for i in range(len(pearson_matrix)):
        plt.plot([i, i+1], [i, i+1], 'k-', linewidth=2)
    
    plt.title(f'Correlações de Pearson (inferior) e Spearman (superior)\n{country}',
              fontsize=16, pad=20, fontweight='bold',
              bbox=dict(
                  facecolor='black',
                  alpha=0.7,
                  edgecolor='none',
                  pad=10,
                  boxstyle='round,pad=0.8'
              ))
    
    # Rotacionar e alinhar os labels dos eixos
    plt.xticks(rotation=45, ha='right')
    plt.yticks(rotation=0)
    
    # Labels dos eixos com fundo preto
    plt.xlabel('Variáveis', 
              fontsize=12, labelpad=10,
              bbox=dict(
                  facecolor='black',
                  alpha=0.7,
                  edgecolor='none',
                  pad=5,
                  boxstyle='round,pad=0.5'
              ))
    
    plt.ylabel('Variáveis', 
              fontsize=12, labelpad=10,
              bbox=dict(
                  facecolor='black',
                  alpha=0.7,
                  edgecolor='none',
                  pad=5,
                  boxstyle='round,pad=0.5'
              ))
    
    plt.tight_layout()
    plt.savefig(pearson_dir / f'pearson_spearman_corr_{country}.png',
                dpi=300,
                bbox_inches='tight',
                facecolor='black',
                edgecolor='none')
    plt.show()
    plt.close()
    
    # 3. Barplot para ETA com melhor visualização
    plt.figure(figsize=(15, 8))
    eta_df = pd.DataFrame(list(correlations['eta'].items()), 
                        columns=['pairs', 'correlation'])
    eta_df[['categorical', 'numerical']] = pd.DataFrame(eta_df['pairs'].tolist())

    # Agrupar por variável numérica (invertido)
    grouped_eta = eta_df.groupby('numerical')

    # Preparar o plot
    categories = eta_df['categorical'].unique()
    x = np.arange(len(categories))
    width = 0.8 / len(grouped_eta)

    # Criar barplot agrupado
    for i, (num, group) in enumerate(grouped_eta):
        # Reorganizar dados para manter ordem consistente
        values = [group[group['categorical'] == cat]['correlation'].iloc[0] 
                if not group[group['categorical'] == cat].empty 
                else 0 
                for cat in categories]
        
        # Calcular posição das barras
        pos = x + (i - len(grouped_eta)/2 + 0.5) * width
        
        # Criar barras
        bars = plt.bar(pos, values,
                    width=width,
                    label=num,
                    alpha=0.8)
        
        # Adicionar rótulos nas barras
        for bar in bars:
            height = bar.get_height()
            if height > 0:  # Mostrar apenas valores positivos
                plt.text(bar.get_x() + bar.get_width() / 2., height,
                        f'{height:.2f}',
                        ha='center', va='bottom',
                        fontsize=9, fontweight='bold',
                        color='white', rotation=90,
                        bbox=dict(
                            facecolor='black', edgecolor='none',
                            alpha=0.7, pad=1, boxstyle='round,pad=0.3'))

    # Configurar eixos e títulos
    plt.title(f'Correlações ETA - {country}', fontsize=16, pad=20)
    plt.xlabel('Variáveis Categóricas', fontsize=12)
    plt.ylabel('Valor ETA', fontsize=12)

    # Ajustar labels do eixo X
    plt.xticks(x, categories, rotation=45, ha='right')

    # Colocar a legenda dentro do gráfico
    plt.legend(title='Variáveis Numéricas',
            loc='best', bbox_to_anchor=(0.5, 1.02),
            ncol=3, fontsize=10, title_fontsize=12, framealpha=0.7)

    # Centralizar e ajustar espaçamento do gráfico
    plt.subplots_adjust(left=0.1, right=0.95, top=0.85, bottom=0.2)
    plt.grid(True, alpha=0.2)

    # Salvar e mostrar
    plt.tight_layout()
    plt.savefig(eta_dir / f'eta_corr_{country}.png', dpi=300, bbox_inches='tight')
    plt.show()
    plt.close()
    
    # 4. V de Cramér e Coeficiente de Contingência
    if correlations['cramer']:
        plt.figure(figsize=(12, 8))

        # Criar matrizes para ambos os coeficientes
        cat_vars = sorted(list(set([cat for pair in correlations['cramer'].keys() for cat in pair])))

        cramer_matrix = pd.DataFrame(0.0, index=cat_vars, columns=cat_vars)
        contingency_matrix = pd.DataFrame(0.0, index=cat_vars, columns=cat_vars)

        for (cat1, cat2), values in correlations['cramer'].items():
            cramer_v = float(values['cramer_v'])
            pearson_c = float(values['pearson_c'])

            # Preencher matriz V de Cramér (triângulo inferior)
            cramer_matrix.loc[cat2, cat1] = cramer_v

            # Preencher matriz Coeficiente de Contingência (triângulo superior)
            contingency_matrix.loc[cat1, cat2] = pearson_c

        # Definir diagonal como NaN
        np.fill_diagonal(cramer_matrix.values, np.nan)
        np.fill_diagonal(contingency_matrix.values, np.nan)

        # Combinar as matrizes
        mask_lower = np.triu(np.ones_like(cramer_matrix), k=1)  # Triângulo inferior
        mask_upper = np.tril(np.ones_like(contingency_matrix), k=-1)  # Triângulo superior

        # Plot do triângulo inferior (V de Cramér)
        sns.heatmap(cramer_matrix,
                    mask=mask_lower,
                    annot=True,
                    cmap='YlOrRd',
                    vmin=0,
                    vmax=1,
                    fmt='.2f',
                    square=True,
                    linewidths=1,
                    cbar_kws={
                        "shrink": .8,
                        "label": "Coeficiente"
                    },
                    annot_kws={
                        "size": 8,
                        "color": "black"
                    })

        # Plot do triângulo superior (Coef. de Contingência)
        sns.heatmap(contingency_matrix,
                    mask=mask_upper,
                    annot=True,
                    cmap='YlOrRd',
                    vmin=0,
                    vmax=1,
                    fmt='.2f',
                    square=True,
                    linewidths=1,
                    cbar=False,
                    annot_kws={
                        "size": 8,
                        "color": "black"
                    })

        # Adicionar linha preta na diagonal
        for i in range(len(cramer_matrix)):
            plt.plot([i, i+1], [i, i+1], 'k-', linewidth=2)

        plt.title(f'Coef. de Cramer (inferior) e Contingência de Pearson (superior) - {country}', fontsize=16, pad=20, fontweight='bold')

        # Configurar eixos e legendas
        plt.xticks(rotation=45, ha='right')
        plt.yticks(rotation=0)
        plt.tight_layout()

        # Salvar e mostrar
        plt.savefig(cramer_dir / f'cramer_contingency_corr_{country}.png', dpi=300, bbox_inches='tight')
        plt.show()
        plt.close()


def plot_lineplot(df, var1, var2, country, output_dir):
    """
    Cria um gráfico de linha entre duas variáveis numéricas.
    
    Args:
        df (DataFrame): DataFrame com os dados
        var1 (str): Nome da primeira variável numérica
        var2 (str): Nome da segunda variável numérica
        country (str): País sendo analisado
        output_dir (Path): Diretório para salvar a imagem
    """

    # Configurar o estilo do gráfico
    plt.style.use('dark_background')
    
    # Criar uma pasta para o gráfico
    lineplot_dir = output_dir / 'NoteBook3' / 'Lineplot'
    lineplot_dir.mkdir(exist_ok=True)
    
    # Criar o gráfico de linha
    plt.figure(figsize=(15, 8))
    sns.lineplot(data=df, x=var1, y=var2, marker='o', color='cyan', linewidth=2)
    
    # Adicionar título e rótulos aos eixos
    plt.title(f'Gráfico de Linha entre {var1} e {var2} - {country}', fontsize=16, pad=20, fontweight='bold',
            bbox=dict(
                facecolor='black',
                alpha=0.7,
                edgecolor='none',
                pad=10,
                boxstyle='round,pad=0.8'
            ))
    
    plt.xlabel(var1, fontsize=12, labelpad=10,
            bbox=dict(
                facecolor='black',
                alpha=0.7,
                edgecolor='none',
                pad=5,
                boxstyle='round,pad=0.5'
            ))
    
    plt.ylabel(var2, fontsize=12, labelpad=10,
            bbox=dict(
                facecolor='black',
                alpha=0.7,
                edgecolor='none',
                pad=5,
                boxstyle='round,pad=0.5'
            ))
    
    # Melhorar visibilidade dos eixos e adicionar uma grade
    plt.xticks(rotation=45, ha='right')
    plt.yticks(rotation=0)
    plt.grid(True, alpha=0.2)
    
    # Ajustar layout e salvar
    plt.tight_layout()
    plt.savefig(lineplot_dir / f'lineplot_{var1}_{var2}_{country}.png', dpi=300, bbox_inches='tight')
    plt.show()
    plt.close()

def plot_violinplot(df, var1, var2, country, output_dir):
    """
    Cria um gráfico de violino entre uma variável numérica e uma variável categórica.
    
    Args:
        df (DataFrame): DataFrame com os dados
        var1 (str): Nome da variável categórica
        var2 (str): Nome da variável numérica
        country (str): País sendo analisado
        output_dir (Path): Diretório para salvar a imagem
    """
    # Configurar o estilo do gráfico
    plt.style.use('dark_background')
    
    # Criar uma pasta para o gráfico
    violinplot_dir = output_dir / 'NoteBook3' / 'Violinplot'
    violinplot_dir.mkdir(exist_ok=True)
    
    # Criar o gráfico de violino
    plt.figure(figsize=(15, 8))
    sns.violinplot(data=df, x=var1, y=var2, palette='Blues', inner="point", linewidth=2)
    
    # Adicionar título e rótulos aos eixos
    plt.title(f'Gráfico de Violino entre {var1} e {var2} - {country}', fontsize=16, pad=20, fontweight='bold',
              bbox=dict(
                  facecolor='black',
                  alpha=0.7,
                  edgecolor='none',
                  pad=10,
                  boxstyle='round,pad=0.8'
              ))
    
    plt.xlabel(var1, fontsize=12, labelpad=10,
               bbox=dict(
                   facecolor='black',
                   alpha=0.7,
                   edgecolor='none',
                   pad=5,
                   boxstyle='round,pad=0.5'
               ))
    
    plt.ylabel(var2, fontsize=12, labelpad=10,
               bbox=dict(
                   facecolor='black',
                   alpha=0.7,
                   edgecolor='none',
                   pad=5,
                   boxstyle='round,pad=0.5'
               ))
    
    # Melhorar visibilidade dos eixos e adicionar uma grade
    plt.xticks(rotation=45, ha='right')
    plt.yticks(rotation=0)
    plt.grid(True, alpha=0.2)
    
    # Ajustar layout e salvar
    plt.tight_layout()
    plt.savefig(violinplot_dir / f'violinplot_{var1}_{var2}_{country}.png', dpi=300, bbox_inches='tight')
    plt.show()
    plt.close()

def plot_3d_with_louvain(data, x_col, y_col, z_col, louvain_col, size_col, country, output_dir):
    """
    Cria um gráfico 3D com variáveis nos eixos x, y e z, onde a cor representa as comunidades Louvain 
    e o tamanho dos pontos é proporcional ao valor da coluna `size_col`. Salva o gráfico como uma imagem.

    Args:
        data (pd.DataFrame): Dataset contendo as variáveis.
        x_col (str): Nome da coluna para o eixo X.
        y_col (str): Nome da coluna para o eixo Y.
        z_col (str): Nome da coluna para o eixo Z.
        louvain_col (str): Nome da coluna com as comunidades Louvain.
        size_col (str): Nome da coluna que determina o tamanho dos pontos (ex.: 'views').
        country (str): Nome do país sendo analisado.
        output_dir (Path): Diretório para salvar a imagem.
    """
    # Obter comunidades únicas e definir uma paleta de cores
    unique_communities = data[louvain_col].unique()
    colors = plt.cm.tab20(np.linspace(0, 1, len(unique_communities)))

    # Criar diretório para salvar o gráfico
    plot3d_dir = output_dir / 'NoteBook3' / '3D_Plots'
    plot3d_dir.mkdir(parents=True, exist_ok=True)

    # Configurar o gráfico 3D
    fig = plt.figure(figsize=(12, 8))
    ax = fig.add_subplot(111, projection='3d')

    # Adicionar pontos ao gráfico
    for i, community in enumerate(unique_communities):
        subset = data[data[louvain_col] == community]
        ax.scatter(subset[x_col], subset[y_col], subset[z_col],
                   color=colors[i],
                   label=f'Comunidade {community}',
                   s=subset[size_col] / subset[size_col].max() * 500,  # Escalar tamanhos dos pontos
                   alpha=0.8,
                   edgecolor='k')  # Contorno dos pontos

    # Configurações dos eixos e título
    ax.set_title(f'Gráfico 3D com Comunidades Louvain - {country}', fontsize=18, pad=20)
    ax.set_xlabel(x_col, fontsize=14, labelpad=10)
    ax.set_ylabel(y_col, fontsize=14, labelpad=10)
    ax.set_zlabel(z_col, fontsize=14, labelpad=10)
    ax.grid(color='gray', linestyle='--', linewidth=0.5, alpha=0.7)

    # Configurar a legenda
    ax.legend(title='Comunidades Louvain', fontsize=12, title_fontsize=14,
              bbox_to_anchor=(1.1, 1), loc='upper left', frameon=True, edgecolor='black')

    # Ajustar layout
    plt.tight_layout()

    # Salvar o gráfico
    output_path = plot3d_dir / f'plot3d_{x_col}_{y_col}_{z_col}_{country}.png'
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    plt.show()
    plt.close()

    print(f"Gráfico 3D salvo em: {output_path}")


# Exemplo de uso
if __name__ == "__main__":
    # Configurar diretórios
    current_dir = Path.cwd()
    country = "PTBR"  # ou outro país
    
    # Carregar dados
    csv_path = current_dir / 'data' / country / f"twitch_network_metrics_{country}.csv"
    output_dir = current_dir / 'docs' / "Imagens" / 'Correlations'
    output_dir.mkdir(exist_ok=True)
    
    # Ler dados
    df = pd.read_csv(csv_path)
    
    # Calcular correlações
    correlations = calculate_correlations(df, country, output_dir)