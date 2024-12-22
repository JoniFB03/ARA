import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc, precision_recall_curve, confusion_matrix, ConfusionMatrixDisplay
from sklearn.model_selection import train_test_split
from pathlib import Path
import pandas as pd

def load_and_predict_links_by_country(current_dir: Path, country: str):
    """
    Função para carregar a rede de um país, fazer previsões de link prediction e avaliar o modelo.

    Parâmetros:
    - country: Nome do país para o qual carregar os dados da rede.

    Retorno:
    - Nenhum.
    """

    assert country in ["PTBR", "DE", "ENGB", "ES", "FR", "RU"]
    assert isinstance(current_dir, Path)
    assert "Twitch" in str(current_dir)

    while current_dir.name != "Twitch":
        current_dir = current_dir.parent

    current_dir = current_dir / "data"
    # Caminho base dos dados (substituir conforme necessário)
    base_path = current_dir / country / f"musae_{country}_edges.csv"

    # Carregar o CSV e criar o grafo
    edge_data = pd.read_csv(base_path, delimiter=',')
    if 'from' in edge_data.columns and 'to' in edge_data.columns:
        edge_data = edge_data[['from', 'to']].astype(int)

    # Criar o grafo diretamente a partir dos dados do pandas
    G = nx.from_pandas_edgelist(edge_data, source='from', target='to')

    # Gerar arestas positivas (existentes na rede)
    edges = list(G.edges())
    non_edges = list(nx.non_edges(G))  # Converter iterador para lista

    # Criar um rótulo binário: 1 para arestas reais, 0 para não-arestas
    pos_edges = [(u, v, 1) for u, v in edges]

    # Selecionar arestas negativas a partir de índices de `non_edges`
    neg_indices = np.random.choice(len(non_edges), size=len(edges), replace=False)
    neg_edges = [(non_edges[i][0], non_edges[i][1], 0) for i in neg_indices]

    # Combinar arestas positivas e negativas
    all_edges = pos_edges + neg_edges

    # Dividir o conjunto em treino e teste
    train_edges, test_edges = train_test_split(all_edges, test_size=0.3, random_state=42)

    # Obter previsões com o método Adamic-Adar
    preds = []
    true_labels = []
    for u, v, label in test_edges:
        common_neighbors = list(nx.common_neighbors(G, u, v))
        score = sum(1 / np.log(G.degree[n]) for n in common_neighbors if G.degree[n] > 1)
        preds.append(score)
        true_labels.append(label)

    # Normalizar previsões
    preds = np.nan_to_num(preds, nan=0.0, posinf=0.0, neginf=0.0)

    # Métricas de avaliação: ROC-AUC e PR-AUC
    fpr, tpr, _ = roc_curve(true_labels, preds)
    roc_auc = auc(fpr, tpr)

    precision, recall, _ = precision_recall_curve(true_labels, preds)
    pr_auc = auc(recall, precision)

    # Gerar a Confusion Matrix
    threshold = 0.5  # Limite de decisão binária
    binary_preds = [1 if p >= threshold else 0 for p in preds]
    cm = confusion_matrix(true_labels, binary_preds)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["Non-Edge", "Edge"])

    # Gráficos
    plt.figure(figsize=(18, 6))

    # Curva ROC
    plt.subplot(1, 3, 1)
    plt.plot(fpr, tpr, label=f'ROC Curve (AUC = {roc_auc:.2f})', color='darkorange')
    plt.plot([0, 1], [0, 1], linestyle='--', color='grey', alpha=0.7)
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Curva ROC')
    plt.legend()

    # Curva de Precisão-Recall
    plt.subplot(1, 3, 2)
    plt.plot(recall, precision, label=f'PR Curve (AUC = {pr_auc:.2f})', color='blue')
    plt.xlabel('Recall')
    plt.ylabel('Precision')
    plt.title('Curva Precisão-Recall')
    plt.legend()

    # Matriz de Confusão
    plt.subplot(1, 3, 3)
    disp.plot(ax=plt.gca(), cmap="Blues", values_format='d')
    plt.title('Confusion Matrix')

    plt.tight_layout()
    plt.show()

    # Mostrar métricas
    print(f"ROC-AUC: {roc_auc:.4f}")
    print(f"PR-AUC: {pr_auc:.4f}")
    print("Confusion Matrix:\n", cm)

if __name__ == "__main__":
    current_dir = Path.cwd()
    load_and_predict_links_by_country(current_dir, "PTBR")