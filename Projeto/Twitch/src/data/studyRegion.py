import pathlib
import networkx as nx
import pandas as pd
from pathlib import Path
import numpy as np
import datetime
from tqdm import tqdm
from allNodesRegions import jogos_offline, non_Videojogos, categorize_game

def AnalyzeCountryNetwork(country: str, current_dir: pathlib.WindowsPath) -> None:
    print(f'\n# ===={country}==== #\n')
    start_time = datetime.datetime.now()

    # Lista de países disponíveis para análise
    countries = ["PTBR", "DE", "ENGB", "ES", "FR", "RU"]

    # Verificar se o país especificado é válido
    assert country in countries
    # Garantir que o diretório atual é do tipo correto e contém "Twitch" no caminho
    assert type(current_dir) == pathlib.WindowsPath and "Twitch" in str(current_dir)

    # Ajustar o caminho para a raiz do diretório "Twitch"
    while current_dir.name != "Twitch":
        current_dir = current_dir.parent

    # Diretório onde estão os dados
    current_dir = current_dir / "data"

    # Caminhos dos ficheiros
    edge_file = current_dir / country / f"musae_{country}_edges.csv"
    target_file = current_dir / country / 'processed_data' / f"Final_musae_{country}_target.csv"

    # Leitura dos dados
    print("A carregar dados...")
    nodes_df = pd.read_csv(target_file)  # Dados dos nodos
    edges_df = pd.read_csv(edge_file)   # Dados das arestas

    # Aplicar categorização aos jogos
    print("A categorizar os jogos...")
    nodes_df['GameType'] = nodes_df['game_name'].apply(categorize_game)

    # Inicializar o grafo
    G_nx = nx.Graph()

    # Adicionar os nós com todas as características do ficheiro target
    print("A adicionar nós...")
    for _, row in tqdm(nodes_df.iterrows(), total=len(nodes_df), desc="Nós processados"):
        G_nx.add_node(row['new_id'], **row.to_dict())

    # Adicionar arestas ao grafo
    print("A adicionar arestas...")
    for _, row in tqdm(edges_df.iterrows(), total=len(edges_df), desc="Arestas processadas"):
        G_nx.add_edge(row['from'], row['to'])

    print(f"Número de nós: {G_nx.number_of_nodes()}")
    print(f"Número de arestas: {G_nx.number_of_edges()}")

    # ==================== #
    # Cálculo de Métricas
    # ==================== #
    print("A calcular métricas...")

    start_metric = datetime.datetime.now()
    degree_centrality = {k: v for k, v in tqdm(nx.degree_centrality(G_nx).items(), desc="Degree Centrality")}
    print(f"Métrica degree_centrality da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    closeness_centrality = {k: v for k, v in tqdm(nx.closeness_centrality(G_nx).items(), desc="Closeness Centrality")}
    print(f"Métrica closeness_centrality da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    betweenness_centrality = {k: v for k, v in tqdm(nx.betweenness_centrality(G_nx).items(), desc="Betweenness Centrality")}
    print(f"Métrica betweenness_centrality da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    eigenvector_centrality = {k: v for k, v in tqdm(nx.eigenvector_centrality(G_nx).items(), desc="Eigenvector Centrality")}
    print(f"Métrica eigenvector_centrality da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    pagerank_centrality = {k: v for k, v in tqdm(nx.pagerank(G_nx).items(), desc="PageRank")}
    print(f"Métrica pagerank_centrality da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    clustering_coef = {k: v for k, v in tqdm(nx.clustering(G_nx).items(), desc="Clustering Coefficient")}
    print(f"Métrica clustering_coef da região {country} demorou {datetime.datetime.now() - start_metric}")

    start_metric = datetime.datetime.now()
    k_core_numbers = nx.core_number(G_nx)
    print(f"K-core calculation completed in: {datetime.datetime.now() - start_metric}")

    # ==================== #
    # Deteção de Comunidades
    # ==================== #
    print("A detetar comunidades...")
    try:
        import community as community_louvain
        louvain_communities = community_louvain.best_partition(G_nx)
    except ImportError:
        print("Biblioteca community-louvain não está instalada.")
        louvain_communities = {}

    lp_communities = nx.community.asyn_lpa_communities(G_nx, weight=None)
    lp_communities = {node: idx for idx, community in enumerate(lp_communities) for node in community}

    # ==================== #
    # Preparar Resultados
    # ==================== #
    print("A consolidar resultados...")
    node_data = []
    for node in tqdm(G_nx.nodes(data=True), desc="Consolidar resultados"):
        node_id = node[0]
        attributes = node[1]
        node_data.append({
            'node': node_id,
            'degree': G_nx.degree[node_id],
            'degree_centrality': degree_centrality.get(node_id, 0),
            'closeness_centrality': closeness_centrality.get(node_id, 0),
            'betweenness_centrality': betweenness_centrality.get(node_id, 0),
            'eigenvector_centrality': eigenvector_centrality.get(node_id, 0),
            'pagerank_centrality': pagerank_centrality.get(node_id, 0),
            'clustering_coef': clustering_coef.get(node_id, 0),
            'louvain_community': louvain_communities.get(node_id, -1),
            'lp_community': lp_communities.get(node_id, -1),
            'k_core': k_core_numbers.get(node_id, 0),
            **attributes  # Adicionar todas as características originais dos nós
        })

    df_metrics = pd.DataFrame(node_data)

    # ==================== #
    # Guardar Resultados
    # ==================== #
    output_file = current_dir / country / 'processed_data' / f"twitch_network_analysis_{country}.csv"
    df_metrics.to_csv(output_file, index=False)
    print(f"Ficheiro CSV com análise guardado em: {output_file}")
    print(f"Tempo total: {datetime.datetime.now() - start_time}\n")


if __name__ == "__main__":
    # Diretório atual
    current_dir = Path.cwd()
    # Listar países a analisar
    countries = ["PTBR", "DE", "ENGB", "ES", "FR", "RU"]
    # Analisar cada país na lista
    for country in tqdm(countries, desc="Países processados"):
        AnalyzeCountryNetwork(country, current_dir)
