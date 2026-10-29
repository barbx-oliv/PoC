# Pocket Chef

## 1. Introducao e Escopo do Sistema
O **Pocket Chef** e uma aplicacao movel desenvolvida com o ecossistema Flutter e Firebase. O sistema atua como um caderno de receitas digital inteligente, permitindo que o usuario busque inspiracoes culinarias por meio de uma API externa e gerencie seu proprio repositorio de receitas favoritas salvas de forma estruturada. Este documento descreve os requisitos, o modelo de dados e a arquitetura basica da solucao, seguindo diretrizes padronizadas de engenharia de requisitos.

## 2. Descricao Operacional e Contexto
O aplicativo opera integrando tres camadas principais:
* Camada de Apresentacao (Frontend em Flutter para dispositivos moveis).
* Camada de Servicos em Nuvem e Autenticacao (Firebase Authentication e Cloud Firestore).
* Camada de Dados de Terceiros (API publica TheMealDB).

### Perfil dos Usuarios
* **Usuario Final:** Pessoa autenticada que busca gerenciar suas proprias receitas favoritas de forma privada e isolada.

## 3. Requisitos Funcionais
* **RF01 - Autenticacao de Usuarios:** O sistema deve permitir o cadastro e o login de usuarios utilizando e-mail e senha atraves do Firebase Authentication.
* **RF02 - Consulta de Receitas Externas:** O sistema deve consumir a API do TheMealDB para buscar pratos com base em termos informados pelo usuario.
* **RF03 - Visualizacao de Detalhes:** O sistema deve exibir informacoes detalhadas de uma receita selecionada, incluindo imagem, titulo, lista de ingredientes e modo de preparo.
* **RF04 - Persistencia de Receitas (CRUD):** O sistema deve permitir que o usuario salve receitas da API em seu perfil pessoal, liste as receitas salvas e remova itens indesejados.

## 4. Requisitos Nao-Funcionais
* **RNF01 - Seguranca de Dados:** Os dados salvos por um usuario devem ser estritamente privados, acessiveis apenas pelo proprio proprietario atraves de regras de seguranca do banco de dados.
* **RNF02 - Desempenho:** A listagem de receitas locais deve responder em tempo real utilizando ouvintes assincronos do banco de dados.

## 5. Modelagem de Dados e Estrutura (Cloud Firestore)

O banco de dados utiliza uma estrutura NoSQL orientada a documentos e subcolecoes para garantir o isolamento adequado dos dados por usuario.

### Tabela de Mapeamento de Dados

| Nível | Caminho / Estrutura | Identificador | Tipos de Dados Principais | Descricao |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `users` | `{userId}` | `email` (String), `createdAt` (Timestamp) | Registros de usuarios autenticados no sistema. |
| 2 | `users/{userId}/savedRecipes` | `{recipeId}` | `idApi` (String), `title` (String), `image` (String), `ingredients` (Array), `instructions` (Array) | Caderno de receitas especifico do usuario logado. |

### Diagrama de Hierarquia de Pastas

```text
users
└── {userId}
    └── savedRecipes
        └── {recipeId}