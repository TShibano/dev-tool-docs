GitHub Flow

```mermaid
gitGraph
   commit id: "Initial commit"
   branch feature/xxx
   checkout feature/xxx
   commit
   commit
   commit
   checkout main
   merge feature/xxx
   branch feature/yyy
   checkout feature/yyy
   commit
   commit
   checkout main
   merge feature/yyy
```

```mermaid
gitGraph
   commit id: "Initial commit"
   branch pre-production
   branch production
   switch pre-production
   commit id: "*"
   switch main
   branch feature/new-feature
   checkout feature/new-feature
   commit id: "Develop new feature"
   commit id: "Develop new feature-foo"
   checkout main
   merge feature/new-feature id: "develop new"
   branch feature/new-feature2
   checkout feature/new-feature2
   commit id: "Develop new feature2"
   checkout main
   merge feature/new-feature2 id: "develop new2"
   switch pre-production
   merge main
   commit id: "Prepare for release"
   checkout production
   merge pre-production tag: "v1.0"
```

### Gitフロー

Git Flowは，Vincent Driessen氏が提唱した体系的なブランチ戦略で，以下のブランチを使用する．

- main：本番環境にリリースされるコードを管理する．
- develop：次のリリースに向けた開発を行うブランチ．
- feature/\*：新機能の開発用ブランチ．developから派生し，開発後にdevelopへマージする．
- release/\*：リリース準備用ブランチ．developから派生し，最終調整後にmainとdevelopへマージする．
- hotfix/\*：本番環境での緊急バグ修正用ブランチ．mainから派生し，修正後にmainとdevelopへマージする．

適した開発条件

- 大規模プロジェクトや計画的なリリースサイクルを持つプロジェクト．
- 複数の開発者が並行して作業するチーム．
- 本番環境と開発環境を明確に分離したい場合．

```mermaid
gitGraph
   commit id: "Initial commit"
   branch develop
   checkout develop
   commit id: "Start development"
   branch feature/awesome-feature
   checkout feature/awesome-feature
   commit id: "Develop feature"
   checkout develop
   merge feature/awesome-feature
   branch release/1.0.0
   checkout release/1.0.0
   commit id: "Prepare release"
   checkout main
   merge release/1.0.0 tag: "v1.0.0"
   checkout develop
   merge release/1.0.0
   branch hotfix/1.0.1
   checkout hotfix/1.0.1
   commit id: "Fix critical bug"
   checkout main
   merge hotfix/1.0.1 tag: "v1.0.1"
   checkout develop
   merge hotfix/1.0.1
```

### トランクベース開発

トランクベース開発は，main（またはtrunk）ブランチを中心に開発を進める戦略で，以下の特徴がある．

- 開発者はmainブランチに直接コミットするか，短命のブランチを使用して作業後すぐにmainへマージする．
- フィーチャーフラグや条件分岐を活用して，未完成の機能を本番環境に影響を与えずにデプロイ可能とする．

適した開発条件

- 継続的デリバリー（CD）を強く推進するプロジェクト．
- 高頻度のデプロイやリリースを行う必要がある場合．
- 小規模チームやアジャイル開発を実践しているチーム．

```mermaid
gitGraph
   commit id: "Initial commit"
   branch feature/short-lived
   checkout feature/short-lived
   commit id: "Quick change"
   checkout main
   merge feature/short-lived
```

## 自作フロー

### 開発フロー

今回，自分の開発スタイルに合わせたブランチ戦略を考える．
Gitフローはブランチ戦略が複雑であり，GitHubフローはブランチ戦略がシンプルすぎるため，その中間的なGitLabフローをメインに考える．
一方で，GitLabフローのpre-productionブランチについて，リリース前の確認のためにブランチを作成する必要ないと考える．
一方で，リリース後のバグ修正のために，bugfixブランチを作成する必要があると考える．
よって，以下のブランチ戦略を採用する．
今回，

- main：開発の主軸となるブランチ
- release：リリースブランチ．mainからマージされる．バージョンごとにタグをつけていく
- feature/\*：新機能や修正を行うブランチ．mainから派生．
- bugfix/\*：バグ修正用ブランチ．releaseから派生．修正後にmainとreleaseへマージする．

補足

- コミットIDの "\*" は，gitGraphを書くために無理やりつけたものであり，実際のgitでは存在しない．

```mermaid
gitGraph
   commit id: "Initial commit"
   branch release
   commit id: "*"
   checkout main
   commit id: "Start development"
   branch feature/new-feature
   checkout feature/new-feature
   commit id: "Develop new feature"
   checkout main
   merge feature/new-feature
   branch feature/new-feature2
   checkout feature/new-feature2
   commit id: "Develop new feature2"
   checkout main
   merge feature/new-feature2
   checkout release
   merge main tag: "v1.0.0"
   branch bugfix/issue-123
   checkout bugfix/issue-123
   commit id: "Fix issue 123"
   checkout release
   merge bugfix/issue-123 tag: "v1.0.1"
   checkout main
   merge bugfix/issue-123
   checkout main
   branch feature/new-feature3
   switch feature/new-feature3
   commit id: "Develop new feature3"
   checkout main
   merge feature/new-feature3
   checkout release
   merge main tag: "v1.1.0"
```

### フォークを用いた開発テンプレートの利用時

開発テンプレートが別のリポジトリにあり，それをフォークして開発を行う場合，以下のブランチ戦略を採用する．

- template：テンプレート開発のブランチ．フォーク元のリポジトリが変更された場合，必要に応じて更新し，mainへマージする．
- main：開発の主軸となるブランチ
- release：リリースブランチ．mainからマージされる．バージョンごとにタグをつけていく
- feature/\*：新機能や修正を行うブランチ．mainから派生．
- bugfix/\*：バグ修正用ブランチ．releaseから派生．修正後にmainとreleaseへマージする．

```mermaid
%%{init: {"gitGraph": {"mainBranchName": "template"}} }%%
gitGraph
   commit id: "Initial commit"
   commit id: "create template"
   branch main
   branch release
   commit id: "*"
   checkout main
   commit id: "Start development"
   branch feature/new-feature
   checkout feature/new-feature
   commit id: "Develop new feature"
   checkout main
   merge feature/new-feature
   switch template
   commit id: "update template3"
   switch main
   merge template
   branch feature/new-feature2
   checkout feature/new-feature2
   commit id: "Develop new feature2"
   checkout main
   merge feature/new-feature2
   checkout release
   merge main tag: "v1.0.0"
   branch bugfix/issue-123
   checkout bugfix/issue-123
   commit id: "Fix issue 123"
   checkout release
   merge bugfix/issue-123 tag: "v1.0.1"
   checkout main
   merge bugfix/issue-123
   checkout main
   branch feature/new-feature3
   switch feature/new-feature3
   commit id: "Develop new feature3"
   checkout main
   merge feature/new-feature3
   checkout release
   merge main tag: "v1.1.0"
```
