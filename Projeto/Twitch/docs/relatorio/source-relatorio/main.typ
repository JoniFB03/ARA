#import "setup/template.typ": *
#include "capa.typ"
#import "setup/sourcerer.typ": code
#show: project
#counter(page).update(1)
#import "@preview/algo:0.3.3": algo, i, d, comment //https://github.com/platformer/typst-algorithms
#import "@preview/tablex:0.0.8": gridx, tablex, rowspanx, colspanx, vlinex, hlinex
#set text(lang: "pt", region: "pt")
#show link: set text(rgb("#004C99"))
#show ref: set text(rgb("#00994C"))
#set heading(numbering: "1.")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 0pt, y: 0pt),
  outset: (y: 3pt),
  radius: 3pt,
)

#page(numbering:none)[
  #outline(indent: 2em, depth: 7)  
  // #outline(target: figure)
]
#pagebreak()
#counter(page).update(1)

#set list(marker: ([•], [‣]))

= Introdução
O presente trabalho foi desenvolvido no âmbito da unidade curricular de *Análise de Redes Avançada*, com o objetivo de estudar e analisar uma rede real. A temática central deste estudo é a análise das redes da *Twitch*, uma plataforma de _live-streaming_ que, ao longo da última década, se consolidou como uma das principais ferramentas de interação e entretenimento digital a nível mundial.

O foco deste estudo incide na exploração dos padrões de interação entre os _streamers_ e na análise das redes regionais que emergem dentro da plataforma, segmentadas pela região. Para tal, foram aplicadas métricas de análise de redes sociais, baseadas em teorias de grafos e técnicas computacionais avançadas, com o intuito de identificar comunidades, padrões de comportamento e estruturas subjacentes que caracterizam as redes presentes na _Twitch_.

Através deste trabalho, pretende-se não apenas contribuir para a compreensão das dinâmicas da plataforma, mas também demonstrar a aplicabilidade prática de conceitos da ciência de redes em contextos do mundo real. Consequentemente, o grupo propôs-se a responder às seguintes questões:
+ As contas *`partner`* da _Twitch_ possuem, de facto, mais visualizações e conexões do que as contas não *`partner`*?
+ As contas mais antigas têm, em média, mais visualizações e conexões do que as contas mais recentes?
+ Existe uma disparidade significativa entre as diferentes regiões analisadas?
+ É possível identificar comunidades dentro da plataforma com base nas características dos _streamers_ e do conteúdo das suas transmissões, como o tipo de jogo ou o foco do conteúdo?

= O que é a _Twitch_? <TwitchOqueser>

Fundada em 2011 e adquirida pela #link("https://www.amazon.com/")[Amazon] em 2014, a _Twitch_ é uma plataforma de transmissão ao vivo (_live-streaming_) focada inicialmente em videojogos, mas que atualmente abrange uma ampla gama de conteúdos, incluindo #link("https://www.twitch.tv/directory/category/music")[música],  #link("https://www.twitch.tv/directory/game/Sports")[desporto], #link("https://www.twitch.tv/directory/game/Art")[arte], e #link("https://www.twitch.tv/directory/game/Just%20Chatting")[conversas ao vivo]. 

A plataforma foi concebida para ser um ponto de encontro para a transmissão de torneios de #link("https://en.wikipedia.org/wiki/Esports")[e-Sports], _streams_ pessoais de jogadores individuais (conhecidos como _streamers_) e programas de entrevistas relacionados a jogos. A página inicial da _Twitch_ atualmente exibe jogos em destaque com base na popularidade e número de visualizações, oferecendo aos utilizadores uma experiência personalizada de navegação através dos conteúdos mais assistidos. Com o passar dos anos, a _Twitch_ expandiu a sua oferta para incluir uma variedade ainda maior de géneros de conteúdo, tornando-se um espaço dinâmico e multifacetado para a criação e consumo de conteúdo digital.


== Como funciona?

A _Twitch_ é uma plataforma que se destaca por quatro características principais:

+ *Transmissões ao vivo*: Criadores de conteúdo, conhecidos como #link("https://www.twitch.tv/")[_streamers_], transmitem ao vivo enquanto jogam, conversam ou realizam outras atividades, criando uma conexão imediata com a audiência.
  
+ *Interação em tempo real*: O #link("https://help.twitch.tv/s/article/chat-basics?language=pt_BR")[_chat_ ao vivo] permite comunicação instantânea entre _streamers_ e espectadores. A tecnologia de #link("https://murf.ai/resources/twitch-text-to-speech/")[_Text-to-Speech_] converte mensagens em áudio, tornando as interações mais dinâmicas.

+ *Monetização*: Os _streamers_ podem ganhar dinheiro de várias formas, como:
  - *Inscrições pagas:*  #link("https://help.twitch.tv/s/article/how-to-subscribe?language=pt_BR")[Subscriptions]
  - *Doações:* #link("https://help.twitch.tv/s/article/charitable-donations?language=pt_BR")[Bits e doações diretas]
  - *Publicidade:* #link("https://twitchadvertising.tv/")[Advertisements]
  - *Parcerias e patrocínios*: #link("https://help.twitch.tv/s/article/partner-program-overview?language=pt_BR")[ Programa de Parceiros]

+ *Programas personalizados*: A _Twitch_ oferece dois programas de apoio:
  - #link("https://www.twitch.tv/affiliates")[*Afiliado:*] permite aos _streamers_ monetizarem-se e personalizarem o conteúdo.
  -  #link("https://help.twitch.tv/s/article/partner-program-overview?language=pt_BR")[*Parceiro:*] oferece mais benefícios, como maior suporte e oportunidades de receita.

           
== Impacto da _Twitch_ na era digital

A _Twitch_ revolucionou a forma como as pessoas consomem conteúdo ao vivo, possibilitando conexões diretas entre criadores e espetadores. Esta dinâmica contribuiu para o sucesso de diversos jogos, como *Among Us* e *Fall Guys*. Além disso, a plataforma oferece uma oportunidade para criadores de diferentes culturas, promovendo a diversidade. No entanto, enfrenta desafios relacionados à moderação, como discursos de ódio, assédio e conteúdo inadequado, embora cada criador tenha a opção de designar moderadores para as suas transmissões. ( #link("https://repositorio.ufc.br/handle/riufc/68512")[Exemplo de Estudo relativamente à Twitch] )

= Revisão de Literatura

/* A _Twitch_ é uma plataforma de streaming ao vivo que pode ser analisada como uma rede social complexa, devido à interação direta entre criadores de conteúdo e a sua audiência. Apesar de ser conhecida como um espaço voltado para jogos, a _Twitch_ também abrange categorias diversificadas, como música, arte, esportes e conversas ao vivo (Just Chatting).

Na análise de redes sociais, a _Twitch_ permite a aplicação de métricas como centralidade, densidade e modularidade. A centralidade destaca os _streamers_ mais influentes, considerados hubs da rede devido ao grande número de seguidores ou inscritos. A densidade avalia o nível de interação dentro de comunidades, medido pela frequência de mensagens no chat ou colaborações entre criadores. Já a modularidade identifica clusters, ou seja, grupos formados por interesses específicos, como fãs de determinados jogos ou categorias de conteúdo.


Nos últimos anos, a análise de redes sociais tem registado um avanço significativo, graças ao desenvolvimento de técnicas baseadas em matrizes e grafos, apoiadas por ferramentas informáticas. Este progresso tem sido complementado pela aplicação de estatística e matemática, que ajudam a tornar as análises mais objetivas e rigorosas.

O enquadramento teórico das redes sociais privilegia as relações entre indivíduos para compreender a estrutura social, contrastando com as abordagens tradicionais das ciências sociais. Nessas abordagens clássicas, parte-se da definição de categorias preexistentes (como classes sociais, grupos ou organizações), para depois se identificar unidades independentes que são posteriormente agrupadas, com o objetivo de analisar a consistência dos seus comportamentos. Contudo, este método tende a desconsiderar informações importantes resultantes das interações entre as entidades sociais.

Embora grande parte das teorias sociológicas tenham um enfoque maior nas relações entre atores, a análise de redes sociais destaca-se por introduzir ferramentas técnicas que permitem verificar empiricamente hipóteses teóricas sobre a natureza das relações e a estrutura das redes. É marcada por ambiguidades devido às diversas interpretações e abordagens em diferentes disciplinas, que atribuem contradições ao conceito de rede. Embora a área tenha avançado, ainda está amplamente associada a um grupo restrito de cientistas sociais que utilizam uma linguagem técnica específica, o que pode dificultar sua adoção por investigadores habituados a abordagens baseadas na lógica dos atributos para estudar fenómenos sociais.


O significado atribuído à análise de redes sociais é alvo de alguma ambiguidade. Estas incertezas decorrem da diversidade de interpretações e abordagens existentes em diferentes disciplinas e correntes, que conferem ao conceito de rede múltiplos significados, muitas vezes contraditórios, dificultando a sua clarificação.Apesar dos avanços na área, a análise de redes sociais ainda está amplamente associada a um grupo restrito de cientistas sociais que utilizam uma linguagem técnica muito específica. Esta característica pode representar um entrave para outros investigadores, particularmente para aqueles que estão mais habituados a trabalhar com abordagens baseadas na lógica dos atributos para estudar fenómenos sociais.


Nesta linguagem técnica, matrizes e grafos destacam-se como ferramentas fundamentais para mapear e ilustrar as interações entre indivíduos, grupos e organizações. No entanto, como apontam Alejandro e Norman (2005), as particularidades da análise de redes sociais tornam inadequadas muitas das ferramentas estatísticas tradicionalmente utilizadas para análises sociais. */


Nos últimos anos, a análise de redes sociais tem avançado significativamente com o suporte de técnicas baseadas em matrizes e grafos, potencializadas por ferramentas informáticas. Estas inovações foram complementadas pela aplicação de estatística e matemática, promovendo análises mais rigorosas e objetivas​.

Embora grande parte das teorias sociológicas enfatize as relações entre atores como nodos, a análise de redes sociais diferencia-se ao incorporar ferramentas técnicas que permitem testar empiricamente hipóteses teóricas sobre a natureza das interações e a estrutura das redes. No entanto, continua a ser um campo repleto de ambiguidades e com muito estudo por desenvolver, devido às múltiplas abordagens em disciplinas diversas, o que leva a interpretações muitas vezes contraditórias do conceito de rede #footnote(link("https://dspace.uevora.pt/rdpc/bitstream/10174/12831/1/20881-41419-1-PB_FINAL.pdf")[Análise de Redes Sociais])​. Entre as ferramentas utilizadas, matrizes e grafos são essenciais para mapear e ilustrar interações. Este enfoque é fundamental, mas apresenta limitações quando se aplicam ferramentas estatísticas tradicionais, muitas vezes inadequadas para captar a dinâmica das redes sociais​. @fialho2014

Adicionalmente, o trabalho de Chandrika et al. (2022) introduz transformadores em grafos para detectar comunidades em redes sociais, capturando proximidades de primeira ordem em espaços latentes e aplicando regularização L0 para evitar sobreajustes e melhorar a generalização. Este modelo foi testado em redes sociais como Facebook e Twitch, no nosso caso, que alcançou resultados superiores de Informação Mútua Normalizada (NMI), quando comparado a métodos tradicionais. @cmc.2022.021186

Outro exemplo são os estudos recentes de Sadhana et al. (2023) e Govinda et al. (2023), que utilizam técnicas de previsão de links (_edges_) para resolver problemas de recomendação na Twitch. Estes trabalhos realçam todo o processo de _feature engineering_ e _selection_ e a utilização de matrizes de correlação para impulsionar e sustentar os resultados. Combina características mais simples, extraídas manualmente, _embeddings_ gerados pelo algoritmo Node2Vec e modelos de _Machine Learning_ para prever a formação de novas conexões. O modelo LightGBM destacou-se como a melhor abordagem, mostrando como previsões baseadas em grafos podem ser aplicadas a redes, como a própria Twitch​.@10133857 @10091004

Estes avanços demonstram como a combinação de técnicas matemáticas e computacionais estão a  redefinir e a mudar a análise de redes sociais, permitindo uma melhor compreensão da sua complexidade estrutural e emergindo as possibilidades de aplicações práticas.


= Esquematização do relatório e trabalho desenvolvido

Neste tópico, serão explicados e referenciados alguns esquemas utilizados ao longo do projeto. O projeto visa analisar a dinâmica das redes sociais da _Twitch_, com foco em interações entre os _streamers_ e as suas audiências, além da estrutura das redes regionais. Para tal, foi necessário implementar diversos algoritmos e análises, cuja implementação pode ser consultada detalhadamente no #link("https://github.com/Vullkano/ARA/tree/main/Projeto/Twitch")[GitHub].

Ao longo do relatório, as palavras #link("https://fenix-mais.iscte-iul.pt/courses/ara-0-565977905417970/fuc")[*azuis*] representam links externos que direcionam para fontes adicionais, enquanto as palavras @ref_EXEMPLO[*verdes*]correspondem a referências específicas dentro deste relatório. Essas referências servem para orientar o leitor e para este se aprofundar nos conceitos discutidos ou nas seções relacionadas do estudo.



#pagebreak()

= Aquisição de dados
== Entendimento das redes a estudar

Para a realização deste projeto, foram extraídas redes da _Twitch_ disponíveis no portal da #link("https://snap.stanford.edu/data/twitch-social-networks.html")[Stanford]. Estas redes fazem parte do #link("https://arxiv.org/abs/1909.13021")[MUSAE], uma coleção de _datasets_ concebida para apoiar pesquisas na área da ciência de redes, _Machine Learning_ em grafos, análise de redes sociais e deteção de comunidades. Os grafos são criados a partir de redes sociais como Facebook, GitHub, _Twitch_, entre outras.

No caso da _Twitch_, os _datasets_ fornecem acesso a redes de 6 línguas diferentes, contendo informações sobre relações _user_-_user_ entre _streamers_, recolhidas em maio de 2018. Estas redes partilham características específicas: são estáticas, porque foram capturadas num único momento no tempo; não direcionadas, dado que as ligações entre dois _streamers_ são sempre mútuas; e tem apenas uma componente conexa ($forall k in G, k_i>=1$), ou seja, a componente gigante é a única componente existente. Como ponto de partida para a análise, é essencial compreender as redes iniciais, tal como foram extraídas, sem quaisquer modificações.

Conforme mencionado, as redes estão segmentadas por idiomas: *DE*, *EN*, *ES*, *FR*, *PT-BR* e *RU*, que correspondem a _streams_ cuja língua principal é, respetivamente, alemão, inglês, espanhol, francês, português (do Brasil) e russo. Os nós representam _streamers_ de uma destas seis línguas, enquanto as arestas representam as amizades entre esses _streamers_.

/*
- *DE*: Streams onde a língua principal é alemão;
- *EN*: Streams onde a língua principal é inglês;
- *ES*: Streams onde a língua principal é espanhol;
- *FR*: Streams onde a língua principal é francês;
- *PT-BR*: Streams onde a língua principal é português do Brasil;
- *RU*: Streams onde a língua principal é russo.
*/

A informação do número de nodos e de arestas de cada uma destas redes encontra-se na @tabela_inicial.

#figure(
  tablex(
    columns: 3,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    // hlinex(),
    [*Idioma da Rede*], [*Nº de nodos*], [*Nº de arestas*],
    hlinex(stroke:0.2mm),
    [DE],  [9498] ,  [153138], [ENGB], [7126], [35324],
    [ES],  [4648] ,  [59382], [FR], [6549], [112666],
    [PT-BR],  [1912] ,  [31299], [RU], [4385], [37304]
),
caption: [Nº de nodos e arestas da rede inicial],
kind:table
)<tabela_inicial>

// Acrescentar mais stats?

É evidente, ao analisar a @tabela_inicial, que existe uma disparidade significativa entre as redes no que diz respeito ao número de nós e arestas. Esta diferença deve-se, principalmente, a fatores relacionados com a dimensão e a atividade da comunidade em cada uma das línguas analisadas.

Para cada uma das línguas, foram fornecidos dois ficheiros: um contendo informações sobre os nós, ou seja, os _streamers_ (*`musae_xxx_target.csv`*), e outro com dados sobre as arestas, representando as ligações entre os _streamers_ (*`musae_xxx_edges.csv`*). O código "*xxx*" em ambos os ficheiros corresponde ao identificador da língua (*DE*, *EN*, *ES*, *FR*, *PT-BR*, *RU*). No ficheiro de nós, tínhamos acesso às seguintes variáveis, cada uma correspondente a um _streamer_:

- *`id`*: Identificador único associado à conta da _Twitch_ do _streamer_. Este valor corresponde ao verdadeiro _id_ utilizado na plataforma _Twitch_ e terá maior relevância na análise com a @API_Twitch.  
- *`days`*: Número de dias desde a criação da conta.  
- *`mature`*: Variável indicadora que especifica se o _streamer_ exibe conteúdo adulto nas suas _streams_.  
- *`views`*: Total de visualizações acumuladas no canal do _streamer_.  
- *`partner`*: Indica se o _streamer_ é um utilizador parceiro da _Twitch_.  
- *`new_id`*: Um identificador único alternativo usado para estabelecer correspondências entre as arestas e os nós.

Estes dados fornecem uma visão detalhada sobre as características dos _streamers_ e permitem uma análise estruturada das redes sociais da _Twitch_.

#pagebreak()

== API da _Twitch_ <API_Twitch>

Na base de dados inicial, existiam duas colunas que representavam _IDs_: *`id`* e *`new_id`*. O campo *`new_id`* refere-se ao _ID_ atribuído a cada nó, utilizado para criar os elos de ligação entre os nós (edges), enquanto o campo `id` corresponde ao _ID_ real da conta da _Twitch_. Essa estrutura permitiu ao grupo identificar a possibilidade de recolher dados mais sensíveis e relevantes sobre os utilizadores, possibilitando a extração de conclusões mais fundamentadas e a realização de um estudo mais aprofundado e detalhado.

Para concretizar esta análise, foi necessário consultar a documentação oficial da _Twitch_, disponível em #link("https://dev.Twitch.tv/docs/api/reference/")[_Twitch_ API Reference]. Adicionalmente, foi necessário gerar um token de acesso e utilizar um *`client_id`*, os quais podem ser obtidos através da #link("https://twitchtokengenerator.com/")[_Twitch_ Token Generator]. Abaixo podemos visualizar um exemplo dos dados recolhidos em formato *`JSON`*, estando identificados o tipo de link recolhido:

#figure(code(lang:"JSON", ```JSON
    {
      id: 141981764,
      login: "davyjones",
      display_name: "DavyJones",
      type: "",
      broadcaster_type: "partner",
      description: "Supporting third-party developers",
      profile_image_url: "https://encurtador.com.br/jS9rY",
      offline_image_url: https:"https://encurtador.com.br/ZGdUa",
      view_count: This field has been deprecated,
      email: "not-real@email.com",
      created_at: 2016-12-14T20:32:28Z
    }
  ```), caption: "GET https://api.Twitch.tv/helix/users")

Acima, podemos visualizar dados recolhidos relativamente às características do utilizador, tais como: o *`display_name`*, que nos fornece o _username_ do _streamer_; o *`created_at`*, que nos fornece a data em que a conta foi criada; e o *`broadcaster_type`* que nos fornece o tipo de streamer, se é afiliado, parceiros, ou nenhum destes.
  
#figure(code(lang:"JSON", ```JSON
    {
      broadcaster_id: 141981764,
      broadcaster_login: "_Twitch_dev",
      broadcaster_name: "_Twitch_Dev",
      broadcaster_language: "en",
      game_id: 509670,
      game_name: "Science & Technology,
      title: "_Twitch_Dev Monthly Update // May 6, 2021",
      delay: 0,
      tags: ["DevsInTheKnow"],
      content_classification_labels: ["Gambling", "DrugsIntoxication", "MatureGame"],
      is_branded_content: False
    }
  ```), caption: "GET https://api.Twitch.tv/helix/channels")

Acima, podemos visualizar dados recolhidos relativamente às características da _livestream_, tais como: o `game_name`, que nos fornece o jogo que está a ser jogado pelo _streamer_ e outras caracteristicas não tão relevantes.

Após a recolha toda, ficámos com as seguintes colunas: | *`id`* | *`days`* | *`mature`* | *`views`* | *`partner`* | *`new_id`* | *`username`* | *`created_at`* | *`profile_pic`* | *`broadcaster_type`* | *`game_name`* |. No @APITwitchVer[Anexo Tópico A] podemos visualizar um _print_ que mostra o processo de recolha dos respetivos dados. É importante destacar que a recolha dos dados apresenta uma limitação, pois estamos a obter informações sobre os streamers mais recentemente, em vez de utilizar dados de 2018, como seria ideal para este estudo. A nossa base de dados original refere-se às interações ocorridas nesse ano, o que pode comprometer a comparação direta e a análise temporal da evolução da plataforma.

Apesar da limitação, seguimos com a limpeza dos dados, pois apresentavam incoerências. A seguir, será explicado o processo realizado.
#pagebreak()
= Tratamento e Análise Exploratória dos Dados

== Existência de contas eliminadas <IDinexistente>
Durante o processo de recolha dos dados, foram identificadas contas que não possuíam características básicas ou essenciais, como o `username`. Para investigar a causa desta anomalia, o grupo procurou uma forma de visualizar uma conta da _Twitch_ utilizando o respetivo `id`. Para tal, foi encontrada uma #link("https://chromewebstore.google.com/detail/_Twitch_-username-and-user/laonpoebfalkjijglbjbnkfndibbcoon?hl=pt")[extensão] do _browser_ que possibilita essa funcionalidade. Na @TwitchAccountDeleted, apresentamos um exemplo de um _id_ que corresponde a uma conta existente e outro que não.


#align(center)[
 #figure(
  grid(
    columns: (210pt, 210pt), gutter: 50pt,
    rows: 1,
    align: (horizon + center),[
      #image("imagens/twitchContaNExiste.png", width: 100%)
    ], image("imagens/twitchContaExiste.png", width: 100%),
  ),
  caption: [
    Exemplo de `id` que existe e outro que não
  ],
) <TwitchAccountDeleted> 
]

Com este problema em mente, procedemos à análise da quantidade de contas eliminadas em cada uma das diferentes regiões. Na @BroadCastType, é possível observar a distribuição das contas eliminadas por região.

#figure(
  grid(
    columns: (400pt, 135pt), gutter: 7pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/nullAllCountry.png", width: 100%),
        rect([

Embora o número de contas eliminadas seja pequeno em comparação ao total de nós na rede (*@tabela_inicial*), a sua remoção causou impactos significativos. Contas que possuíam apenas uma ligação com os nós removidos tornaram-se isoladas, afetando a conectividade da rede e prejudicando suas interações. Como resultado, foi atribuído a estas contas a característica de *`deleted_account`*.

          
], inset: 5pt,
  fill: rgb("fff"),
  width: 100%,
  stroke: 0.2pt, radius: (
    left: 1pt,
    right: 5pt,
  )),
  ),
  caption: [
    Total de contas eliminadas por região
  ],
) <BroadCastType>

Este é um exemplo de uma das limitações da recolha de dados realizada através da _API_ da _Twitch_ (@API_Twitch) para este trabalho. Para uma análise mais precisa, seria necessário obter dados específicos de 2018 ou realizar uma nova recolha atualizada, que incluísse as interações, amizades e visualizações mais recentes. No entanto, tal recolha seria extremamente exigente em termos de recursos computacionais, dado que a recolha de dados através da _API_ da _Twitch_ levou cerca de 4 horas para obter informações de 34118 contas, sem considerar as amizades dos utilizadores. Apesar disso, o grupo optou por utilizar os dados disponíveis e continuou com o estudo.


#pagebreak()

== Características Gerais das regiões

Como mencionado anteriormente, existem seis regiões da _Twitch_ a serem analisadas. De forma geral, é esperado que os valores e comportamentos dessas regiões não apresentem diferenças significativas. Tendo isso em consideração, será realizada, primeiramente, uma análise geral para identificar as regiões mais interessantes para uma análise detalhada.

=== `Broadcast_Type`

Para solucionar o problema identificado na @IDinexistente, foram realizados ajustes na variável *`broadcaster_type`*. É importante destacar que esta variável representa uma extensão de informação relacionada aos *programas personalizados* da _Twitch_ mencionados na @TwitchOqueser. Assim, o grupo implementou as seguintes alterações/acréscimos:

- Nos casos em que o *`username`* apresentava o valor *NaN*, o nó correspondente foi classificado como *_account_deleted_*, refletindo as contas eliminadas mencionadas na @IDinexistente.
- Para os demais casos, foi atribuído o valor *_non_streamers_*, representando contas existentes que não possuem qualquer *programa personalizado* associado.

Os resultados obtidos com estas modificações podem ser visualizados na @NewBroadcast_Type.


#align(center)[
  #figure(
image("imagens/broadcaster_types_distribution_all_countries.png", width: 100%),
  caption: [Total de contas eliminadas por região]
) <NewBroadcast_Type>
] 

A variável *`broadcast_type`* categoriza os _streamers_ da _Twitch_ de acordo com o seu nível de atividade e status na plataforma. As categorias possíveis são:  

- *_Partner_*: _streamers_ reconhecidos por alcançarem um elevado nível de influência na plataforma.  
- *_Affiliate_*: _streamers_ que cumprem os critérios básicos para monetização.  
- *_Account Deleted_*: Contas que foram removidas ou desativadas.  
- *_Non-Streamer_*: Contas que não realizam transmissões.  

A região _*PTBR*_ destaca-se por ter uma elevada proporção de _Partners_ e _Affiliates_ em relação ao total de _broadcasters_, sugerindo uma comunidade mais ativa e monetizada. As contas eliminadas representam uma pequena fração em todas as línguas, sendo mais frequentes nas regiões _*DE*_ e _*RU*_, enquanto _*PTBR*_ tem o menor número. Por fim, as contas _Non-Streamer_ são mais comuns nas regiões _*DE*_ e _*FR*_, enquanto a região _*PTBR*_ apresenta a menor proporção, indicando uma taxa maior de utilizadores que transmitem ativamente.

#pagebreak()

=== `Mature`

Na _Twitch_, uma conta é classificada como *`mature`* quando o seu conteúdo é direcionado a um público adulto, geralmente por conter linguagem explícita, temas sensíveis ou outro tipo de material não recomendado para todas as idades. Na @Mature, podemos visualizar a quantidade, e a proporção, de contas de conteúdo adulto para cada uma das regiões.

#align(center)[
  #figure(
image("imagens/mature_nodes_distribution_all_countries.png", width: 100%),
  caption: [Total de contas eliminadas por região]
) <Mature>
] 

A região _*PTBR*_ apresenta 34,5% das contas classificadas como *`Mature`*, sendo a que possui o menor número absoluto de nós com conteúdo adulto. Em contrapartida, a região _*DE*_ destaca-se com o maior número de nós classificados como conteúdo adulto, representando 60% dos nós como *`Mature`*. Na região _*ENGB*_, há um equilíbrio entre nós *`Mature`* (55%) e *`Non-Mature`* (45%). Por outro lado, na região _*ES*_, 71% dos nós são classificados como *`Non-Mature`*, indicando uma predominância de conteúdos não adultos. A região _*FR*_ tem 63% de nós classificados como *`Non-Mature`*. Finalmente, a região _*RU*_ apresenta a maior proporção de nós *`Non-Mature`*, com 76%. Em resumo, as regiões _*DE*_ e _*ENGB*_ concentram mais conteúdos adultos, enquanto _*ES*_ e _*RU*_ apresentam uma preferência por conteúdos acessíveis a todos, com _*PTBR*_ destacando-se pela menor quantidade de nós totais.

=== `content_type_comparison_all_countries` <escolhajogosfixemanual>
Na _Twitch_, cada vez que um canal realiza uma _stream_, é-lhe associada uma _tag_ que identifica o tipo de conteúdo transmitido, seja relacionado com videojogos ou não. Tendo isso em conta, o grupo teve a ideia de agrupar os tipos de conteúdo em 4 grandes categorias, sendo essas:
- *On-Videogame Channels*: Canais dedicados a conteúdos relacionados com videojogos focados em _gameplays on-line_. Exemplos comuns são _streamers_ que jogam _League of Legends_, _Fortnite_ ou _Valorant_.
- *Off-Videogame Channels*: Canais dedicados a conteúdos relacionados com videojogos focados em _gameplay off-line_. Exemplos comuns são _streamers_ que jogam _The Last of us II_, _Dark Souls_ ou _Cyberpunk 2077_.
- *Non-Videogame Channels*: Canais que não têm qualquer relação com videojogos ou temas digitais. Estes podem abranger áreas como culinária, moda, vlogs ou discussões políticas.
- *Non-Content*: Categoria que engloba canais que não possuem conteúdo relevante ou estão fora do contexto da análise, como canais não ativos ou contas que nunca realizaram uma stream.
Tendo esta noção dos conceitos na @Content_Type, podemos visualizar a quantidade de nós existentes em cada uma das classes referidas anteriormente.

#align(center)[
  #figure(
image("imagens/content_type_comparison_all_countries.png", width: 100%),
  caption: [Total de contas eliminadas por região]
) <Content_Type>
] 

Os resultados mostram que os jogos mais transmitidos na _Twitch_ são os focados em experiência online, como *League of Legends*, *Valorant* e *Overwatch II*. Estes jogos são competitivos e não seguem uma história fixa/linear, o que significa que os espectadores não precisam começar do zero para entender o que está a acontecer. Eles podem entrar a meio do jogo e focar-se em aprender as táticas e estratégias que os _streamers_ estão a usar. Além disso, a natureza competitiva faz com que todos, tanto _streamers_ quanto espectadores, se envolvam emocionalmente, acompanhando partidas e discutindo jogadas, quer seja com o streamer ou entre si. Isso cria uma experiência interativa que gera mais visualizações e partilhas.

== Cálculo das métricas gerais das regiões <met_geral_reg>

A explicação teórica de todas as métricas encontra-se no @DetailMetricsAllRegion[Anexo - Tópico B]

=== *_Métricas de Conectividade da Rede_*

A explicação teórica de todas as variáveis encontra-se nos @MetricasConectividadeRedeAnexo[Anexos - *_Métricas de Conectividade da Rede_*.]

#figure(
  tablex(
    columns: 7,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,6).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Country*], [*Number of Nodes*], [*Number of Edges*], [*Diameter*], [*Density*], [*Average Path Length*],
    [*Radius*],
    hlinex(stroke:0.2mm),
    [*PTBR*],  [1912], [31299], [7], [0.017132], [2.532379], [4],
    
    [*DE*],  [9498], [153138], [7], [0.003395], [2.721571], [4],
    
    [*ENGB*], [7126], [35324], [10], [0.001391], [3.677616], [10],
    
    [*ES*], [4648], [59382], [9], [0.005499], [2.883191], [9],
    
    [*FR*], [6549], [112666], [7], [0.005255], [2.680991], [7],
    
    [*RU*], [4385], [37304], [9], [0.003881], [3.021095], [9]
),
caption: [Métricas de Conectividade da Rede],
kind:table
)<ConectCaracteristicas>

- A análise revela que a região *PTBR* possui o menor número de *nós* (*`Number of Nodes`*), enquanto a região *DE* apresenta o maior. Da mesma forma, em relação ao número de *arestas* (*`Number of Edges`*), *PTBR* é a região menos conectada, enquanto *DE* se destaca com o maior número. 

- O *`Diameter`* da rede é maior na região *ENGB* (*10*), sugerindo ser a menos conectada, enquanto as regiões *PTBR*, *DE* e *FR* apresentam um valor menor (*7*), indicando redes mais conectadas. Em relação ao *`Radius`*, *PTBR* e *DE* demonstram ser regiões altamente conectadas, com um valor de *4*, contrariamente com *ENGB*, que novamente exibe características de desconexão. 

- A *`Density`* da rede é maior em *PTBR*, indicando uma interação mais intensa entre as contas da _Twitch_, enquanto *ENGB* apresenta uma densidade muito baixa. 
- Por fim, o *`Average Path Length`* reflete a mesma tendência: a região *PTBR* destaca-se como a mais unida e conectada, facilitando a troca de informações e interações, enquanto *ENGB* apresenta o valor mais elevado, reforçando a percepção de uma rede mais fragmentada.

=== *_Métricas de Eficiência e Estrutura_*

A explicação teórica de todas as variáveis encontra-se nos @MetricasEficienciaEstruturaAnexos[Anexos - *_Métricas de Eficiência e Estrutura_*.]

#figure(
  tablex(
    columns: 4,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,6).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Country*], [*Assortativity*], [*Global Efficiency*], [*Heterogeneity*],
    hlinex(stroke:0.2mm),
    [*PTBR*], [-0.232462], [0.422379], [3.908783],
    
    [*DE*], [-0.115173], [0.389143], [7.915203],
    
    [*ENGB*], [-0.121908], [0.288730], [6.009056],
    
    [*ES*], [-0.189051], [0.369027], [4.736978],
    
    [*FR*], [-0.178151], [0.394712], [6.072479],
    
    [*RU*], [-0.182289], [0.353563], [7.000328]
),
caption: [Métricas de eficiência e estrutura da Rede],
kind:table
)<StructureCaracteristicas>

- A variável *`Assortativity`* mostra que todas as regiões apresentam valores negativos, o que indica que utilizadores com características ou graus diferentes estão mais propensos a conectar-se. Isso reflete-se no facto de utilizadores com poucos seguidores frequentemente conectarem-se a _streamers_ populares (os _hubs_), criando um padrão de interação que favorece a centralização. 

- Em relação à variável *`Global Efficiency`*, a região *PTBR* apresenta a eficiência global mais alta, indicando que a informação ou as conexões são transmitidas de forma mais eficiente na rede desse país, enquanto a região *ENGB* apresenta a menor eficiência global, sugerindo uma rede menos otimizada para interação rápida entre _streamers_. 

- Para a variável *`Heterogeneity`*, todos os valores das regiões são elevados (acima de 1), o que indica uma distribuição desigual ou heterogénea dos graus dos nós na rede, sugerindo a presença de _hubs_ (os _streamers_ mais populares). No entanto, a região *PTBR* apresenta o menor valor de *`Heterogeneity`*, refletindo uma maior uniformidade nas conexões entre as contas. Por outro lado, a região *RU* possui o maior valor de *`Heterogeneity`*, evidenciando a presença mais pronunciada de _hubs_ na rede.


=== *_Métricas de Centralidade_*

A explicação teórica de todas as variáveis encontra-se nos @metricas.de.centralidade[Anexos - *_Métricas de Centralidade_*.]

#set text(10pt)

#figure(
  tablex(
    columns: 6,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    [*Country*], [*Degree*], [*Betweenness*], [*Closeness*], [*Eigenvector*], [*PageRank*],
    hlinex(stroke:0.2mm),
    [*PTBR*], [0.017132], [0.000802], [0.401857], [0.014118], [0.000523],
    
    [*DE*], [0.003395], [0.000181], [0.373517], [0.005512], [0.000105],
    
    [*ENGB*], [0.001391], [0.000376], [0.276473], [0.005923], [0.000140], 
    
    [*ES*], [0.005499], [0.000405], [0.352079], [0.008450], [0.000215], 
    
    [*FR*], [0.005255], [0.000257], [0.378272], [0.007270], [0.000153],  
    
    [*RU*], [0.003881], [0.000461], [0.337113], [0.007905], [0.000228],
),
caption: [Métricas de Centralidade (média) dos Países],
kind:table
)<centralidadeCaracteristicas>

#set text(11pt)

- Após analisar as métricas de centralidade, observou-se que, na *`Degree Centrality (mean)`*, a região *PTBR* é a mais bem conectada, enquanto a região *ENGB* apresenta contas mais isoladas. 

- Quanto à *`Betweenness Centrality (mean)`*, os valores indicam que, de maneira geral, não existem muitas contas que conectam diferentes comunidades, devido ao baixo valor dessa métrica. 

- Na *`Closeness Centrality (mean)`*, a *PTBR* destaca-se por ter uma maior percentagem de _streamers_ impactantes, que conseguem interagir de forma mais eficiente, ao passo que a região *ENGB* apresenta valores mais baixos. 

- A *`Eigenvector Centrality (mean)`* revela que a região *PTBR* possui maior proximidade entre os _streamers_, com os mais importantes mais conectados entre si, enquanto a *DE* apresenta valores mais baixos, sugerindo que os _streamers_ mais importantes não interagem tanto entre si. 

- Finalmente, na *`PageRank Centrality (mean)`*, a alta conectividade na *PTBR* facilita a interação entre _streamers_, tornando mais fácil encontrar determinados _streamers_, ao contrário da região *DE*, onde os maiores _streamers_, o "coração" das comunidades, estão mais separados.

=== *_Métricas de Centralização_*

A explicação teórica de todas as variáveis encontra-se nos @metricas.e.centralizacaoAnexo[Anexos - *_Métricas de Centralização_*.]

#figure(
  tablex(
    columns: 3,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    // hlinex(),
    [*Country*], [*Degree Centralization*], [*Betweenness Centralization*],
    hlinex(stroke:0.2mm),
    [*PTBR*],  [0.384228],	[0.098459],
    [*DE*],  [0.445062],	[0.291061],
    [*ENGB*], [0.099661],	[0.126391],
    [*ES*], [0.214428],	[0.110712],
    [*FR*], [0.306291],	[0.100029],
    [*RU*], [0.276457],	[0.176945],
),
caption: [Características dos Nós],
kind:table
)<NodeCaracteristicas>

- A região *DE* é a região com um valor de *`Degree Centralization`* maior, dando a entender que nesta região existe um maior desequilíbrio de conexões, por outras palavras, existem poucos _streamers_ com muitas conexões. Do outro lado da moeda, temos a região da *ENGB* que é o total oposto.

- De forma geral, as regiões não possuem um valor muito alto de *`Betweenness Centralization`*, mas a região *DE* é a que apresenta o valor mais alto, dando a entender que há poucos _streamers_ muito importantes que permitem a ligação entre as diferetens comunidades; temos a região *PTBR* que apresenta o menor valor, por consequência da alta conectividade da rede.

=== *_Agrupamento e Comunidades_*

A explicação teórica de todas as variáveis encontra-se nos @Agrupamento-e-comunidadesAnexo[Anexos - *_Agrupamento e Comunidades_*.]

#set text(10pt)

#figure(
  tablex(
    columns: 4,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    // hlinex(),
    [*Country*], [*Av. Clustering Coefficient*], [*Modularity*], [*Transitivity*],
    hlinex(stroke:0.2mm),
    [*PTBR*],  [0.319895], [0.293737], [0.130981],
    
    [*DE*], [0.200886], [0.289176], [0.046471],
    
    [*ENGB*], [0.130928], [0.452409], [0.042433],
    
    [*ES*], [0.222496], [0.406823], [0.084235],
    
    [*FR*], [0.221706], [0.346773], [0.054128],
    
    [*RU*], [0.165797], [0.338307], [0.048648],
),
caption: [Qualidade de agrupamentro e de criação de comunidades],
kind:table
)<ComCaracteristicas>

#set text(11pt)

- Ao longo do relatório, foi possível visualizar que a região *PTBR* é aquela mais conectada, enquanto a região *ENGB* é aquela mais dispersa, com _streamers_ mais bem separados pelas suas comunidades. Os valores da @ComCaracteristicas corroboram aquilo que já foi dito anteriormente. 

- A @ComCaracteristicas demonstra que a região *ENGB* é a melhor região para visualizar comunidades, já que nesta as contas encontram-se mais dispersas e os _hubs_ não se encontram conectados (visualizar a @centralidadeCaracteristicas). As piores regiões para se identificarem comunidades distintas são: a *DE* e a *PTBR*.

- Mais um vez, em primeiro lugar temos a região *PTBR* que apresenta uma alta formação de comunidade interligadas, devido à sua alta conectividade, enquanto a região *ENGB* é aquela que aparenta ser mais dispersa.

=== `K-Cores`

A explicação teórica de todas as variáveis encontra-se nos @k-coresAnexo[Anexos - *`K-Cores`*.]

#figure(
  tablex(
    columns: 4,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    // hlinex(),
    [*Country*], [*Number of Nodes in $K_text("Max")$-Core*], [*Number of Edges in $K_text("Max")$-Core*], [*$K_text("Max")$*],
    hlinex(stroke:0.2mm),
    [*PTBR*],  [154], [4384], [37],
    
    [*DE*], [350], [13266], [43],
    
    [*ENGB*], [277], [3263], [14],
    
    [*ES*], [367], [10319], [33],
    
    [*FR*], [351], [10981], [40],
    
    [*RU*], [128], [2497], [23],
),
caption: [$K_text("Max")$-Core],
kind:table
)<K-Cores>

- Relativamente ao valor do $K_"max"$-cores, é notório que a comunidade central mais forte e densa é a da região *DE*. De forma surpreendente, a região *PT-BR* está em terceiro lugar, estando atrás da região *FR*. A comunidade central mais fraca é a da *ENGB*

- Para realizar uma análise e comparação correta entre cada região, é necessário calcular a percentagem dos nós dos *`k-cores`*, já que o número absoluto difere entre cada região. Para tal, serão usados os dados da @ConectCaracteristicas e será feito o seguinte cálculo: *$text("Percentagem de nós no K")_"max" "Core") = ("Número de nós no K"_"max"-"Core")/text("Número total de nós da rede") times 100$*. A região com uma comunidade central mais forte, relativamente ao percentual de $K_"max" "cores"$, é a *PTBR* com um valor de 8.05%; enquanto a menos densa é a *RU*, com um valor de 2.92%.

- Para realizar uma análise e comparação correta entre cada região, é necessário calcular a percentagem das arestas dos *`k-cores`*, já que o número absoluto difere entre cada região. Para tal, serão usados os dados da @ConectCaracteristicas e será feito o seguinte cálculo: *$text("Percentagem de arestas no K")_"max" "Core") = ("Número de arestas no K"_"max"-"Core")/text("Número total de arestas da rede") times 100$*. A região com mais interações, relativamente aos *`K-Cores`*, é a *ENGB* com um valor de 0.78%; enquanto a menos densa é a *DE*, com um valor de 0.23%.


Na @K-CoresPERC, podemos visualizar todos os valores calculados através das fórmulas referidas anteriormente:

#figure(
  tablex(
    columns: 3,
    align: (col, row) => {
      if row == 0 {
        center
      } else if (0,5).contains(col) {
        center
      } else {center}
    },
    header-rows:1,
    auto-lines: false,
    // hlinex(),
    [*Country*], [* $K_text("Max")$-Core nodes ( Total % )*], [* $K_text("Max")$-Core edges ( Total % )*],
    hlinex(stroke:0.2mm),
    [*PTBR*],  [8.054393 %], [ 0.492028 %],
    
    [*DE*], [3.684986 %], [0.228552 %],
    
    [*ENGB*], [3.887174 %], [ 0.784169 %],
    
    [*ES*], [7.895869 %], [0.618032 %],
    
    [*FR*], [5.359597 %], [ 0.311540 %],
    
    [*RU*], [2.919042 %], [0.343127 %],
),
caption: [$K_text("Max")$ Core ( Total % )],
kind:table
)<K-CoresPERC>

== Cálculo das métricas individuais de cada região

Após uma análise geral de todas as regiões em @met_geral_reg, verificou-se que, embora apresentem valores diferentes, as regiões partilham características semelhantes, como a dificuldade em formar comunidades coesas, a pouca variação na distribuição de categorias de jogos e tipos de transmissões, e pequenas diferenças nas métricas numéricas. Com base nisso, decidiu-se focar apenas nas regiões com características distintas para evitar uma análise redundante. As regiões selecionadas foram:

- *PTBR*: Caracteriza-se por comunidades muito unidas, com contas centrais que conectam diferentes grupos.
- *ENGB*: Apresenta uma configuração dispersa, com hubs fracos e poucas conexões significativas entre eles.

// Essa escolha permite explorar dinâmicas contrastantes: a coesão e centralidade da região PTBR em oposição à fragmentação e dispersão da região ENGB. Este enfoque visa garantir que a análise seja rica em insights e que forneça uma compreensão aprofundada das dinâmicas sociais específicas de cada uma destas regiões.

=== Análise detalhada da região *PTBR*

Para iniciar esta avaliação, podemos observar a visualização de um subgrafo da rede @redePTBR, que ilustra o quão coesa e conectada é essa rede.

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_PTBR.png", width: 90%),
  caption: [Sub-Grafo da região *PTBR* (10% nodos para facilitar visualização)]
) <redePTBR>
] 

==== Estudo dos graus da região *PTBR*

Para realizar um estudo adequado da distribuição dos graus nesta região, utilizaremos a visualização logarítmica da @degreeDistributionPTBR, que nos dará uma visão geral da proporção de nós com poucas ligações em comparação com os que possuem mais conexões. Além disso, vamos investigar a possível presença de _power law_ nesta região, utilizando a @PowerLawPTBR. A _power law_ é comum em redes sociais e é característico de sistemas que possuem uma estrutura de "_hubs_", onde certos nós possuem um número desproporcionalmente alto de conexões em relação ao restante da rede; isto é, um pequeno número de _streamers_ de grandes seguidores (os _hubs_) domina a plataforma, enquanto a maioria dos _streamers_ possui uma audiência menor (ou nenhuma audiência).

#figure(
  grid(
    columns: (400pt, 120pt), gutter: 10pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/LogHistogram_degree_PTBR.png", width: 100%),
        rect([

À esquerda, podemos observar a distribuição da quantidade de nós em função dos seus graus, apresentada em escala logarítmica. Ao analisar com mais detalhe, é evidente que, à medida que o grau aumenta, a quantidade de nós com esse grau diminui, sendo estes nós representativos dos _streamers_ mais famosos.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Distribuição logarítmica dos graus da região *PTBR*
  ],
) <degreeDistributionPTBR>

#figure(
  grid(
    columns: (140pt, 390pt), gutter: 10pt,
    rows: 1,
    align: (horizon + center),
    rect([

Ao lado direito, é notório a existência de _power law_ nesta região, pois a maioria dos _streamers_ tem um número relativamente pequeno de seguidores ou interações, enquanto alguns _streamers_, os mais influentes, têm números extremamente altos de amizades. A fórmula geral de uma _power law_ é expressa como:

$P(x) prop x^(-alpha)$
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
    image("imagens/PowerLaw_degree_PTBR.png", width: 100%),
  ),
  caption: [
    _Power Law_ da região *PTBR*
  ],
) <PowerLawPTBR>

Podemos, assim, concluir a presença de _hubs_ nesta região, evidenciada pela existência de poucos _streamers_ mais famosos, com um grande número de conexões, e, por outro lado, muitos _streamers_ com poucas conexões, como era de se esperar.

==== Correlações das variáveis da região de *PTBR* <ExplicaCorrPTBR>

Antes de prosseguirmos para a análise dos valores, é importante ressaltar que as variáveis foram devidamente tratadas e serão explicadas sempre que surgirem relações de interesse. Além disso, serão utilizadas as seguintes abordagens: *Pearson e Spearman* para variáveis contínuas versus contínuas; *ETA* para variáveis contínuas versus categóricas; e os coeficientes de *Cramer e Contingência de Pearson* para variáveis categóricas versus categóricas.

===== Correlação de Pearson & Spearman

#figure(
  grid(
    columns: (420pt, 107pt), gutter: 11pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/pearson_spearman_corr_PTBR.png", width: 100%),
        rect([

A @pearsonSpearmanPTBR apresenta dois triângulos com modelos diferentes de correlação. O triângulo inferior exibe a correlação de Pearson, que é usada para avaliar a força e a direção de uma relação linear entre variáveis numéricas. O triângulo superior exibe a correlação de Spearman, que é uma medida de correlação não paramétrica, adequada para identificar relações monotónicas entre as variáveis, independentemente de serem lineares ou não.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Correlação de Pearson & Spearman da região *PTBR*
  ],
) <pearsonSpearmanPTBR>

Ao analisar os valores, é evidente que não existem correlações muito fortes entre as variáveis, exceto em casos de métricas calculadas, ou seja, variáveis que foram derivadas a partir de outras. No entanto, uma correlação que se destaca é a forte associação entre a variável *`views`* e a *`degree`*. Isso sugere que um _streamer_ com um número elevado de *`conexões`* tende a ter um número significativamente maior de *`views`*, o que implica que, de forma geral, _streamers_ com mais interações na rede possuem maior visibilidade e, consequentemente, mais visualizações. Na @lineplotViewDegreePTBR podemos então visualizar essa relação:

#figure(
  grid(
    columns: (390pt, 140pt), gutter: 14pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/lineplot_degree_views_PTBR.png", width: 100%),
        rect([

A @lineplotViewDegreePTBR revela uma tendência linear, apesar de alguns picos intermédios, confirmando a análise prévia sobre a relação entre as variáveis *`views`* e *`degree`*. Esses picos podem indicar pontos específicos ou exceções na rede, mas a tendência geral continua a apoiar a hipótese de que _streamers_ com mais conexões têm, em média, mais visualizações.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Line Plot entre o `degree` e as `views` da região *PTBR*
  ],
) <lineplotViewDegreePTBR>

===== Correlação de ETA

Antes de prosseguirmos com a análise dos valores do *ETA*, é importante destacar algumas alterações realizadas nas variáveis. Inicialmente, foram criadas comunidades utilizando os algoritmos de *`Louvain`* e *`Label Propagation Algorithm`*, cuja aplicação será detalhada posteriormente na @comunidadesPTBR. Em seguida, foram incorporados os valores de *K* provenientes do *`K-core`*. Além disso, foram consideradas as seguintes características: se o jogo é online (*`is_online`*), se o conteúdo não é um Video-jogo (*`nonGame`*), se a conta é parceira da _Twitch_ (*`is_partner`*) e se o conteúdo é direcionado para adultos (*`is_mature`*).

#figure(
  grid(
    columns: (120pt, 400pt), gutter: 10pt,
    rows: 1,
    align: (horizon + center),
    rect([

A correlação de ETA possibilita analisar a relação entre variáveis categóricas e numéricas. No gráfico à direita, o eixo x representa as variáveis categóricas, enquanto o eixo y indica os valores de correlação. Cada barra do gráfico corresponde a uma variável numérica.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 100%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
    image("imagens/eta_corr_PTBR.png", width: 100%),
  ),
  caption: [
    Correlação de *ETA* da região *PTBR*
  ],kind:image
) <eta_corrPTBR>

Analisando detalhadamente os valores, é evidente que as variáveis com as correlações mais altas são: *`louvain_community`*, *`k_core`* e *`is_partner`*. As comunidades serão discutidas mais adiante (@comunidadesPTBR). Em relação à variável *`is_partner`*, é interessante observar a forte correlação com *`degree`*, o que sugere que contas parceiras da _Twitch_ tendem a ter mais visualizações. Esta relação pode ser visualizada na @ViolinPlotPTBR. Quanto aos *`k-cores`*, também há uma boa correlação com *`degree`*. Vale ressaltar que, embora *`degree`* apresente uma correlação forte com *`views`*, como mostrado na @pearsonSpearmanPTBR, não se observa uma correlação igualmente forte entre *`views`* e *`k-cores`* ou *`is_partner`*.

#figure(
  grid(
    columns: (385pt, 145pt), gutter: 15pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/violinplot_is_partner_degree_PTBR.png", width: 100%),
        rect([

O *violin plot* demonstra que há uma maior quantidade de nós com menos `views` quando o _streamer_ não é parceiro. Por outro lado, quando o _streamer_ é parceiro, observa-se uma maior concentração de contas com mais `views`. No entanto, ainda persiste algum ruído, representado pelas contas que, mesmo sendo parceiras, não apresentam uma quantidade elevada de `views`.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    *Violin Plot* entre o *`is_partner`* e o *`degree`* da região *PTBR*
  ],
) <ViolinPlotPTBR>

===== Coeficiente de Cramer e Contingência de Pearson

#figure(
  grid(
    columns: (370pt, 160pt), gutter: 5pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/cramer_contingency_corr_PTBR.png", width: 90%),
        rect([

O gráfico é similar ao da *@pearsonSpearmanPTBR*, com a diferença nas variáveis categóricas e nos modelos de correlação utilizados. As correlações são, de modo geral, fracas, exceto nos algoritmos de comunidade (*`Louvain`* e *`Label Propagation Algorithm`*). O destaque vai para o *`k-core`*, que tem uma forte correlação com os algoritmos de comunidade e com a variável *`is_partner`*, indicando que os nós com maior *degree* são frequentemente parceiros da _Twitch_, como já foi observado no gráfico de violino *@ViolinPlotPTBR*.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Coeficiente de *Cramer* (triângulo inferior) e *Contigência de Pearson* (triângulo superior) da região *PTBR*
  ],
) <CramerPTBR>

==== Comunidade da região *PTBR* <comunidadesPTBR>

Como já foi mencionado anteriormente, foram utilizados os algoritmos *`Louvain`* e *`Label Propagation Algorithm`*. De forma geral, as comunidades criadas pelo *`Label Propagation Algorithm`* não são muito coerentes, estando excessivamente sub-divididas e apresentando resultados inferiores aos obtidos com o algoritmo *`Louvain`*. Tendo isso em conta, será apenas discutido o algoritmo *`Louvain`*.
Apesar do exposto, o grupo chegou à conclusão de que as métricas utilizadas e as variáveis de perfil não são suficientes para categorizar as comunidades de forma eficaz, o que é visível na @eta_corrPTBR e na @CramerPTBR. Para comprovar isto, iremos utilizar a visualização da @plot3DPTBR.

#figure(
  grid(
    columns: (180pt, 400pt), gutter:-10pt,
    rows: 1,
    align: (horizon + center),
    rect([

A @plot3DPTBR apresenta um gráfico 3D com os seguintes eixos: `mature` no eixo X, `k_core` no eixo Y e `closeness_centrality` no eixo Z. Cada ponto representa um _streamer_, cuja cor indica a sua comunidade, de acordo com o algoritmo `Louvain`, e cujo tamanho é proporcional ao valor de `views`. Apesar da visualização, os padrões entre as comunidades são pouco evidentes, tornando difícil compreender as estruturas subjacentes criadas pelo algoritmo.

          
], inset: 7pt,
  fill: rgb("fff"),
  width: 100%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
image("imagens/plot3d_mature_k_core_closeness_centrality_PTBR.png", width: 90%),
  ),
  caption: [
    Plot3D das comunidades da região *PTBR*
  ],kind:image
) <plot3DPTBR>

#pagebreak()

=== Análise detalhada da região *ENGB*

Para iniciar esta avaliação, podemos observar a visualização de um subgrafo da rede @redeENGB, que ilustra o quão esparsa e enorme é esta rede.

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_ENGB.png", width: 100%),
  caption: [Sub-Grafo da região *ENGB* (10% nodos para facilitar visualização)]
) <redeENGB>
]

==== Estudo dos graus da região *ENGB*

Na @PowerLaw_DistributionDegreeENGB, podemos observar o comportamento da rede da região *ENGB* em relação aos nós. Como esperado, as conclusões são semelhantes às da região *PTBR*. A distribuição logarítmica segue um padrão similar ao da @degreeDistributionPTBR, com a única diferença de apresentar um número maior de _streamers_ com poucas `edges` e, consequentemente, um menor número de _streamers_ com um número elevado de `edges`. Quanto ao *Power Law*, a conclusão é idêntica à da @PowerLawPTBR.


#align(center)[
 #figure(
  grid(
    columns: (260pt, 260pt), gutter: 5pt,
    rows: 1,
    align: (horizon + center),[
      #image("imagens/LogHistogram_degree_ENGB.png", width: 100%)
    ], image("imagens/PowerLaw_degree_ENGB.png", width: 100%),
  ),
  caption: [
    Distribuição logarítmica dos graus e _PowerLaw_ da região *ENGB*
  ],
) <PowerLaw_DistributionDegreeENGB> 
]

==== Correlações das variáveis da região de *ENGB*

Esta secção seguirá o mesmo estilo da @ExplicaCorrPTBR.

==== Correlações das variáveis da região de *ENGB*

===== Correlação de Pearson & Spearman

#figure(
  grid(
    columns: (420pt, 107pt), gutter: 15pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/pearson_spearman_corr_ENGB.png", width: 100%),
        rect([

O valor das correlações da região *ENGB* são muito semelhantes aos da região *PTBR* (@pearsonSpearmanPTBR), com alterações quase insignificativas nos valores. Algo interessante de se notar é que seria normal esperar que uma conta criada há mais tempo (*`created_year`*), ou, por outras palavras, que tenha mais dias de existência (*`days`*), fosse uma conta com muitas *`views`* e *`degrees`*, mas, em ambas as regiões, isso não ocorre.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Correlação de Pearson & Spearman da região *ENGB*
  ],
) <pearsonSpearmanENGB>

#line(length: 100%)
#set text(15pt)
#align(center)[*Nota*]
#set text(11pt)

#rect(fill: rgb("f5fffa"), inset: 12pt,
  width: 100%,
  stroke: 1pt,  radius: (
    left: 5pt,
    right: 5pt,
  ))[#quote(attribution: [Grupo ARA])[No @DetailviewsSingleRegion[Anexo - Tópico B],  podemos observar o subgrafo das características das outras regiões que não foram analisadas anteriormente, nomeadamente 
 @DetailsDEanexo1[*DE*], @DetailsESanexo1[*ES*], @DetailsFRanexo1[*FR*], @DetailsRUanexo1[*RU*]]] 

===== Correlação de ETA | Cramer e Contingência | Comunidades da região *ENGB* 
#figure(
  grid(
    columns: (120pt, 400pt), gutter: 10pt,
    rows: 1,
    align: (horizon + center),
    rect([

Mais uma vez, as únicas variáveis com correlação elevada de *ETA* são: *`k_core`*, *`is_partner`* e as variáveis relacionadas às comunidades. Portanto, as conclusões deste gráfico são praticamente idênticas às apresentadas em @eta_corrPTBR.
          
], inset: 7pt,
  fill: rgb("fff"),
  width: 100%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
    image("imagens/eta_corr_ENGB.png", width: 100%),
  ),
  caption: [
    Correlação de *ETA* da região *ENGB*
  ],kind:image
) <eta_corrENGB>



#figure(
  grid(
    columns: (370pt, 130pt), gutter: 15pt,
    rows: 1,
    align: (horizon + center),
    image("imagens/cramer_contingency_corr_ENGB.png", width: 100%),
        rect([

Como mencionado no gráfico anterior, o mesmo padrão é observado aqui. Os valores das correlações de *Cramer* e da *contingência de Pearson* são muito semelhantes aos da @CramerPTBR. Mais uma vez, as comunidades apresentam uma forte correlação entre si, e o *`K_core`* está correlacionado com a variável *`louvain_community`*.

          
], inset: 7pt,
  fill: rgb("fff"),
  width: 110%,
  stroke: 0.1pt, radius: (
    left: 5pt,
    right: 5pt,
  )),
  ),
  caption: [
    Coeficiente de *Cramer* (triângulo inferior) e *Contigência de Pearson* (triângulo superior) da região *ENGB*
  ],
) <CramerENGB>

Ao longo da análise da região *PTBR*, é notório que os valores de correlação são muito semelhantes em praticamente todas as variáveis, apesar das diferenças mencionadas na @met_geral_reg, como a rede *ENGB* ser mais esparsa que a *PTBR*, possuir mais nós e conexões, e a *ENGB* ser menos densa, entre outras. Apesar dessas diferenças, os valores de correlação mantêm-se semelhantes, o que leva à conclusão de que será difícil realizar uma análise aprofundada das comunidades, tal como observado na @plot3DPTBR.

#pagebreak()

= Conclusão

A #link("https://pt.wikipedia.org/wiki/Twitch")[_Twitch_] (@TwitchOqueser) é uma plataforma híbrida que combina as características de uma #link("https://pt.wikipedia.org/wiki/Rede_social")[rede social] com um serviço de #link("https://pt.wikipedia.org/wiki/Live_streaming")[_streaming_], o que facilita a criação de novas contas e o estabelecimento de relações entre os utilizadores. Este fenómeno é crucial para entender as dinâmicas de interação e a formação de comunidades dentro da plataforma. Visualmente, as diferentes regiões analisadas apresentam algumas diferenças evidentes. Por exemplo, a região *PTBR* possui menos nós e conexões quando comparada com a região *ENGB*, mas é consideravelmente mais densa (conforme mostrado na @met_geral_reg). No entanto, ao calcular e comparar as métricas, observámos que não existe uma disparidade significativa entre as regiões, apenas algumas variações subtis. Isso sugere que, apesar das diferenças visuais, a interação entre utilizadores de diferentes países pode ser mais homogénea do que à primeira vista aparenta. As visualizações das outras regiões não analisadas ( @DetailsDEanexo1[*DE*], @DetailsESanexo1[*ES*], @DetailsFRanexo1[*FR*], @DetailsRUanexo1[*RU*]) estão disponíveis em anexo para uma melhor apreciação.

Vale ressaltar que, embora as métricas utilizadas tenham sido recolhidas e manipuladas com dados atualizados, a base de dados utilizada é de 2018 (#link("https://snap.stanford.edu/data/twitch-social-networks.html")[Stanford]), o que impõe algumas limitações à análise. Um exemplo disso é a existência de contas eliminadas, que não foram facilmente previstas ou compreendidas, prejudicando a interpretação dos dados. Além disso, a atualização constante dos jogos na plataforma significa que os *streamers* de 2018 podem ter mudado os seus hábitos e preferências, o que torna os dados desatualizados em termos de jogo. Um outro ponto a ser mencionado é a interpretação dos jogos realizada pelo grupo na @escolhajogosfixemanual, que pode não ter sido a mais precisa. O processo envolveu a análise de cada jogo para determinar se deveria ser classificado como *`Online`* ou *`Offline`*, com base no seu foco principal. Essa tarefa de categorização, além de consumir tempo, pode não ter sido a mais rigorosa, dado o caráter subjetivo da análise.

A evolução contínua da plataforma e o aumento no número de utilizadores tornam a base de dados de 2018 menos representativa do estado atual da Twitch, o que introduz algum ruído nas conclusões obtidas.

Realizámos também um teste preliminar de #link("https://en.wikipedia.org/wiki/Link_prediction")[*`link prediction`*] para a região *PTBR* utilizando o método #link("https://en.wikipedia.org/wiki/Adamic%E2%80%93Adar_index")[Adamic-Adar] (@linkPredictTestPTBR). O código implementado, apesar de interessante, não avançou devido à dificuldade em detectar padrões de comunidade de forma interpretativa, uma vez que os métodos utilizados baseiam-se apenas em lógica matemática. O teste não contribuiu significativamente para o trabalho, pois a complexidade da rede e a sua evolução dificultam a obtenção de conclusões definitivas.

Em resumo, a Twitch é uma plataforma extremamente difícil de estudar devido ao seu tamanho, o que gera ruído nas análises, e à sua evolução constante. As contas *partner*, em geral, são aquelas com maior grau de conectividade e visualizações. Curiosamente, as contas mais antigas nem sempre possuem mais visualizações ou maior grau de interação, o que desafia algumas das expectativas comuns sobre o crescimento e a popularidade dos utilizadores na plataforma.


#align(center)[
  #figure(
image("imagens/linkPredictionTest.png", width: 100%),
  caption: [_Link Prediction test_ na região *PTBR* ]
)  <linkPredictTestPTBR>
]

#pagebreak()

#set heading(numbering: none)

#bibliography("setup/ficheiro.bib", full:true)

#pagebreak()

= Anexos
#set heading(numbering: (level1, level2,..levels ) => {
  if (levels.pos().len() > 0) {
    return []
  }
  ("Anexo", str.from-unicode(level2 + 64)/*, "-"*/).join(" ")
}) // seria so usar counter(heading).display("I") se nao tivesse o resto
//show heading(level:3)

======== Referência exemplo <ref_EXEMPLO>

Apenas para visualizar a organização do relatório :)

\

======== Tópico A - API Twitch <APITwitchVer>

#align(center)[
  #figure(
image("imagens/API_Twitch.jpg", width: 100%),
  caption: [Recolha dos dados da _Twitch_]
)
]

A imagem acima demonstra o processo de recolha dos dados da _Twitch_ através da sua _API_. 

#pagebreak()

======== Tópico B - Detalhe sobre todas as métricas utilizadas <DetailMetricsAllRegion>

========= *_Métricas de Conectividade da Rede_* <MetricasConectividadeRedeAnexo>

#line(length: 100%)

1. *`Number of Nodes`*: Refere-se ao número de _streamers_ presentes na rede.

2. *`Number of Edges`*: Indica a quantidade de conexões entre os _streamers_.

3. *`Diameter`*: Na teoria dos grafos, o diâmetro de um grafo é a maior distância geodésica entre dois nós, ou seja, o número máximo de arestas no caminho mais curto entre dois nós quaisquer. \ Pode ser descrito pela seguinte fórmula: $ l_max = max_(i,j)l_(i,j) $ \ Em relação à rede social da _Twitch_, onde os nós representam _streamers_ e as arestas representam conexões de amizade, o diâmetro indica o quão distantes ou conectados estão os utilizadores na rede. Um diâmetro pequeno sugere uma rede bem conectada, onde os utilizadores podem alcançar uns aos outros rapidamente, enquanto um diâmetro grande indica uma rede mais dispersa, com comunidades ou utilizadores mais isolados.

4. *`Radius`*: O radius é a menor distância máxima entre um nó e os demais, identificando o nó mais central ou acessível na rede. Foi utilizada a #link("https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.distance_measures.radius.html")[função do NetworkX] `radius(G, e=None, usebounds=False, weight=None)` para o cálculo desta métrica.\ Na Twitch, o raio indica o streamer ou grupo mais próximo do restante da comunidade, atuando como um ponto central para disseminação de conteúdo e interações, refletindo a coesão e conectividade da rede.

5. *`Density`*: A densidade mede o quão conectados estão os nós em relação ao número máximo de conexões possíveis.\ Na _Twitch_, a densidade de uma rede reflete o nível de interações entre _streamers_, como colaborações ou partilha de audiência. Uma alta densidade indica uma comunidade altamente interligada, enquanto uma baixa densidade sugere maior fragmentação. Esta métrica é útil para avaliar a coesão das comunidades e o potencial de disseminação de conteúdo na plataforma.\ Em termos matemáticos, e como as redes a estudar tratam-se de redes não orientadas, elas são calculadas da seguinte forma: $ d=(2L)/(N-(N-1)) $. Isto indica que quão maior for o rácio entre ligações e nodos, mais completa será a rede. Ou seja, se $L >>> N$.

6. *`Average Path Length`*: O _average path length_ (comprimento médio dos caminhos) é a média das distâncias mínimas entre todos os pares de nós que é definida da seguinte forma (para uma rede não orientada): $ <l> = (2 sum_(i,j)l_(i,j))/(N(N-1)) $. \ Na _Twitch_, essa métrica indica o quão rapidamente um _streamer_ ou conteúdo pode ser alcançado dentro de uma comunidade. Um valor baixo sugere maior proximidade entre os _streamers_, onde é beneficiada a interação e a disseminação de público, enquanto um valor alto pode refletir maior dispersão ou segmentação na rede.

#pagebreak()

======== *_Métricas de Eficiência e Estrutura_* <MetricasEficienciaEstruturaAnexos>

#line(length: 100%)

1. *`Assortativity`*: A associação mede a tendência de nós se conectarem a outros nós com características semelhantes, como o grau. Foi utilizada a #link("https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.assortativity.degree_assortativity_coefficient.html#r9f11600ff61a-1")[função do NetworkX]: `degree_assortativity_coefficient(G)`. \ Na _Twitch_, ela reflete se streamers mais populares interagem mais entre si ou com streamers menores. Uma alta associação indica comunidades polarizadas, enquanto uma baixa sugere maior diversidade de conexões, influenciando a dinâmica de colaboração e crescimento na plataforma.

2. *`Global Efficiency`*: A eficiência global mede a facilidade de comunicação em toda a rede, considerando o inverso das distâncias entre os nós. Foi utilizada a #link("https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.efficiency_measures.global_efficiency.html")[função do NetworkX]: `global_efficiency(G)`. \ No contexto da _Twitch_, esta métrica reflete o quão rápido o conteúdo ou interações podem se propagar entre os _streamers_, que reflete numa rede mais conectada e funcional para compartilhar audiência e colaboração.

3. *`Heterogeneity`*: A heterogeneidade avalia o grau de variação nas conexões entre os nós, indicando se há nós altamente conectados em contraste com outros menos conectados. Isto quer dizer que a distribuição de grau tem uma cauda longa (_heavy-tailed_), em que muitos nodos têm poucos adjacentes e poucos nodos têm muitos adjacentes. \ Em termos matemáticos, o parâmetro de heterogeneidade é calculado com a seguinte expressão: $ kappa = grau2/grau^2 $ Se este valor for muito superior a 1 ($kappa>>1$), indica que há uma distribuição de grau heterogénea e que a rede provavelmente tem _hubs_.\ Na _Twitch_, a heterogeneidade representa a disparidade entre _streamers_ com grandes audiências e aqueles com menos alcance.

#pagebreak()

======== *_Métricas de Centralidade_* <metricas.de.centralidade>

#line(length: 100%)

*NOTA*: Apesar destas medidas de centralidade serem normalmente utilizadas para cada nó, estas foram calculadas e posteriormente transformadas para a média para facilitar a explicação, de certa forma. Como representa uma medida de dispersão, este valor, para as diferentes medidas, deve ser considerado em vários nodos da rede. Ou seja, um valor elevado significa que os nodos estão todos muito próximos dos restantes (proximidade), ou que muitos nodos são "pontes" para outros nodos (intermediação), por exemplo. Contudo, espera-se que estes valores sejam baixos porque há muitos nodos com valor 0 de centralidade, que influencia a média "negativamente". Nesses casos servirá como comparação entre redes de regiões diferentes; que é possível graças à normalização pelo número de nodos *`betweenness_centrality(G, k=None, normalized=True)`* (para a de medida centralidade de intermediação, por exemplo).

#line(length: 100%, stroke: (dash: "dashed"))

1. *`Degree Centrality (mean)`*: Representa o número médio de conexões diretas que os nós têm na rede. \ Na _Twitch_, isto reflete, em média, quantas amizades ou interações os _streamers_ têm com outros. Um valor elevado indica que, em média, os _streamers_ estão bem conectados, enquanto valores baixos sugerem nós mais isolados.
  
2. *`Betweenness Centrality (mean)`*: Mede a frequência com que os nós atuam como pontes no caminho mais curto entre outros nós. Podemos calcular a medida da seguinte forma: $ b_i= sum_((h,j):h,j != i) (sigma_(h,j)(i))/sigma(h,j) $ e da forma normalizada para o número de nodos: $ tilde(b_i)= (sum_((h,j):h,j != i) (sigma_(h,j)(i))/sigma(h,j))/((N-1)(N-2))/2 $ \ Na _Twitch_, isto reflete o papel médio dos _streamers_ em conectar comunidades separadas. _Streamers_ com valores altos podem ser grandes "_influencers_" que unem grupos ou comunidades linguísticas diferentes.

3. *`Closeness Centrality (mean)`*: Avalia a proximidade média dos nós a todos os outros na rede. A medida normalizada é calculada da seguinte forma: $ tilde(g_i)= (N-1)/(sum_(j != i)l_(i,j)) $. \ Na _Twitch_, isto indica o quão rapidamente, em média, um _streamer_ pode alcançar qualquer outro _streamer_. Valores altos sugerem que os _streamers_ estão "*estrategicamente* bem posicionados" para interações rápidas e acessíveis.

4. *`Eigenvector Centrality (mean)`*: Considera não apenas o número de conexões de um nó, mas também a importância das conexões. \ Na _Twitch_, isto avalia a relevância média dos _streamers_, considerando as conexões com outros _streamers_ influentes que aumentam ainda mais a sua importância.
  
5. *`PageRank Centrality (mean)`*: Mede a probabilidade média de um nó ser alcançado por uma navegação aleatória, considerando a qualidade das conexões. \ Na _Twitch_, isto reflete a visibilidade média dos _streamers_, com valores altos indicando maior probabilidade de serem descobertos por utilizadores devido às suas conexões com _streamers_ relevantes.

#pagebreak()

======== *_Métricas de Centralização_* <metricas.e.centralizacaoAnexo>

#line(length: 100%)

A *centralidade* e a *centralização* são conceitos fundamentais em análise de redes, mas eles possuem significados e aplicações distintas. A seguir, descrevemos as principais diferenças entre esses dois conceitos, com base em literatura científica.

- A *#link("chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://viterbi-web.usc.edu/~shanghua/NetworkEssence.pdf")[centralização]:* refere-se ao grau em que uma rede como um todo depende de um ou poucos nós centrais. Em outras palavras, ela mede a distribuição da centralidade ao longo de toda a rede. Quanto maior a centralização, mais a rede depende de poucos nós dominantes.

- *#link("https://academic.oup.com/book/27303")[Diferença Principal]:*
   - *Centralidade* foca na *importância de um nó individual*.
   - *Centralização* foca na *distribuição dessa importância ao longo da rede*.
   
Enquanto *centralidade* mede a posição de um nó dentro da rede, *centralização* avalia a distribuição da importância na rede como um todo.

#line(length: 100%, stroke: (dash: "dashed"))

1. *`Degree Centralization`*: Mede o quão centralizada é a rede em torno de um ou poucos nós com muitas conexões (hubs). Na _Twitch_, uma alta `Degree Centralization` indica que poucos _streamers_ têm muitas conexões diretas, dominando as interações na plataforma, enquanto valores baixos sugerem uma distribuição mais equilibrada das conexões entre os _streamers_.
  
2. *`Betweenness Centralization`*: Avalia o quão dependente a rede está de certos nós para conectar diferentes partes da mesma. Na _Twitch_, uma alta `Betweenness Centralization` implica que poucos _streamers_ desempenham um papel crucial em unir diferentes comunidades. Valores baixos indicam que as conexões são mais distribuídas, com menor dependência de intermediários específicos.

#pagebreak()

======== *_Agrupamento e Comunidades_* <Agrupamento-e-comunidadesAnexo>

#line(length: 100%)

#let CoefC = {
  $#h(-1pt)<#h(0pt)#text(baseline: 0.5pt)[C]#h(0pt)>#h(1pt)$
}

1. *`Average Clustering Coefficient`*: Mede a tendência dos nós na rede para formarem triângulos, ou seja, grupos de nós altamente interligados. Dá-se pela fórmula seguinte: $ CoefC = (sum_(i:k_(i>1)) C(i))/(N_(k>1)) $onde são considerados apenas os nodos com grau superior a 1, ou seja, todas as componentes conexas (sem nós "soltos").\ Na _Twitch_, isso reflete o nível de coesão local entre os _streamers_. Um valor elevado indica que os _streamers_ têm uma maior probabilidade de se conectar com os amigos dos seus amigos, criando comunidades mais próximas e coesas.

2. *`Modularity`*: Mede a força da divisão da rede em comunidades ou grupos. Valores elevados indicam que a rede pode ser claramente segmentada em subgrupos bem definidos, como comunidades de _streamers_ com interesses ou públicos específicos. No nosso caso, a detecção de comunidades foi realizada utilizando o algoritmo `Louvain`, com a melhor partição pela fórmula: $ Q=(1)/(2m) sum_(i,j) (A_(i,j)-gamma_(=1) (k_i k_j)/(2m)) delta (c_i, c_j) $ da #link("https://networkx.org/documentation/stable/reference/algorithms/generated/networkx.algorithms.efficiency_measures.global_efficiency.html")[função do NetworkX]: `modularity(G, communities, weight='weight', resolution=1)`. \ Na _Twitch_, uma alta `Modularity` obtida pelo método `Louvain` revela a existência de _clusters_ de _streamers_ que interagem mais frequentemente dentro das suas comunidades.

3. *`Transitivity`*: é uma medida global de agrupamento que a proporção de triângulos na rede em relação ao número total de pares conectados. Ou seja, $T= 3 times ("#triangles")/("#triads")$.\ No nosso contexto, uma alta `Transitivity` sugere que a plataforma tem muitas conexões triangulares entre _streamers_, o que reforça a formação de comunidades interligadas, enquanto valores mais baixos indicam uma estrutura mais dispersa.

======== `K-Cores` <k-coresAnexo>

+ *$#raw("K")_#raw("max")$*: O $K_"max"$ representa o maior número de conexões mínimas que todos os nós dentro do ($K_"max"-"cores"$) Core possuem. No contexto da Twitch, indica o nível mais alto de densidade que uma sub-rede de streamers pode atingir, onde todos têm pelo menos $K_"max"$ amigos.


+ *`Number of Nodes in K-Core`*: Representa o número de _streamers_ mais robustos e interligados dentro de uma determinada rede na _Twitch_. O `K-Core` é uma sub-rede onde todos os _streamers_ têm pelo menos *k* conexões mútuas, indicando um grupo central de criadores que colaboram ou interagem frequentemente. Um número elevado de nós no `K-Core` sugere uma comunidade central forte e ativa.


+ *`Number of Edges in K-Core`*: Refere-se ao número de relações ou conexões entre os _streamers_ na sub-rede `K-Core`. Estas conexões refletem interações consistentes entre os membros mais envolvidos da comunidade. Um elevado número de arestas no `K-Core` indica uma rede central densa, com muitas interações mútuas entre os principais _streamers_.

#pagebreak()

======== Tópico C - Visualização das Sub-Redes de cada uma das regiões <DetailviewsSingleRegion>

======== Detalhes da região *DE* <DetailsDEanexo1>

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_DE.png", width: 100%),
  caption: [Sub-Grafo da região *DE* (10% nodos para facilitar visualização)]
) <redeDE>
]

======== Detalhes da região *DE* <DetailsESanexo1>

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_ES.png", width: 100%),
  caption: [Sub-Grafo da região *ES* (10% nodos para facilitar visualização)]
) <redeES>
]

======== Detalhes da região *FR* <DetailsFRanexo1>

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_FR.png", width: 100%),
  caption: [Sub-Grafo da região *FR* (10% nodos para facilitar visualização)]
) <redeFR>
]

======== Detalhes da região *RU* <DetailsRUanexo1>

#align(center)[
  #figure(
image("imagens/subgrafo_rede_twitch_RU.png", width: 100%),
  caption: [Sub-Grafo da região *RU* (10% nodos para facilitar visualização)]
) <redeRU>
]

