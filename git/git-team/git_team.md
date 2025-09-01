---
marp: true
theme: a4-document
paginate: true
---

<!-- class:  title-page -->

<div class="title">
    Gitチーム活用編
</div>

<div class="meta">
citrus88<br>
citrus.mikan88@gmail.com<br>
初版: 2025/08/05<br>
更新日: 2025/08/05<br>
</div>

---

# はじめに

## 想定読者

- Gitを使ったチーム開発を行いたい人

## 本資料のゴール

- Gitを使ってチーム開発ができる

## この資料で説明しないこと

- Gitの基本的な内容
- GitHub/GitLabの詳細な使い方

# チーム開発におけるGitの利点

- すべての変更履歴が完全に記録されるため、問題が発生した際に原因となった変更を特定し、責任の所在を明確にできる
- 各開発者が独立してブランチで作業を行い、完成した機能を統合することで、お互いの作業を妨げることなく開発を進められる
- 中央のリモートリポジトリを通じて、常に最新かつ安定したコードを共有できるため、チーム全体の作業効率が向上する
- 分散版本管理システムにより、各開発者がローカルで完全な履歴を持つため、ネットワークが不安定な環境でも安定した開発が可能
- コンフリクト(競合)が発生した場合でも、Gitの強力なマージ機能により安全に解決でき、複数人での同時編集によるデータ消失を防げる

---

# Gitのブランチ戦略

まず，Gitのブランチ戦略について紹介する．
Gitを用いてチームで開発する時，ブランチを適切に管理することで、開発効率を向上させることができる．
ここでは，よく使われてシンプルなGitHub Flowについて説明する．

## GitHub Flow

GitHub Flowはシンプルで理解しやすいブランチ戦略である．少人数の開発で用いられ，頻繁にリリースする場合に適している．GitHub Flowのキーポイントは，「mainブランチが常に本番環境と同期している．すべての作業ブランチはmainから分岐してコードレビューを通してmainにマージされる」ことである．作業ブランチは開発内容に合わせてfeature, bugfix, docsなどと名前をつける．．作業ブランチは一つのブランチ内での変更内容の粒度を小さくし，短い間隔でmainへマージできるようにする．

- **main**：常にデプロイ可能な状態を保つ
- **feature, bugfix, docs**：作業用のブランチ．
  - **feature**：新機能開発用のブランチ（`feature/機能名`）
  - **bugfix**：バグ修正用のブランチ（`bugfix/バグ名`）
  - **docs**：ドキュメント更新用のブランチ（`docs/ドキュメント名`）

GitHub Flowの流れは以下である．

1. 新しいfeatureブランチを作成
2. 機能開発とコミット
3. プルリクエスト(マージリクエスト)を作成
4. コードレビュー
5. mainブランチにマージ
6. 本番環境にデプロイ

GitHub Flowのブランチの様子は以下である．
![GitHub Flow](./imgs/GitHub_Flow.png)

- [GitHub Docs](https://docs.github.com/ja/get-started/using-github/github-flow)

それ以外の有名なブランチ戦略は以下である．

- Git Flow
  - 複数の長期ブランチ（main/develop）とフィーチャーブランチを使用する複雑なブランチ戦略
  - [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- GitLab Flow
  - GitHub Flowをベースに環境別ブランチを追加したシンプルかつ柔軟なワークフロー
  - [GitLab Flow](https://about.gitlab.com/ja-jp/topics/version-control/what-is-gitlab-flow/)
- Trunk-Based Flow
  - メインブランチに頻繁に小さなコミットを直接行う最もシンプルな開発手法
  - [Trunk Based Flow](https://www.atlassian.com/ja/continuous-delivery/continuous-integration/trunk-based-development)

---

# チーム開発の流れ

## Gitを用いてチーム開発する時の流れ

1. (初回のみ)リモートリポジトリの作成する
2. (初回のみ)リモートリポジトリをローカル環境に複製する(clone)
3. ブランチ戦略に沿って，ブランチ作成する
4. ファイルの編集・コミットし，開発を進める
5. ブランチをリモートリポジトリへプッシュする
6. レビューを行う
7. マージする
8. 各開発者はmainブランチの変更履歴をローカルリポジトリに取り込み，必要に応じて現在作業しているブランチにも取り込む．

---

## リモートリポジトリの作成

GitHubやGitLabでリポジトリを作成する．

- [GitLabでのリポジトリ作成方法](https://docs.gitlab.com/ee/user/project/README.html#create-a-project)
- [GitHubでのリポジトリ作成方法](https://docs.github.com/ja/repositories/creating-and-managing-repositories/creating-a-new-repository)

## リモートリポジトリの複製

GitHub/GitLab上のリポジトリにアクセスし，URLをコピーする．その後，作業するPC上でターミナルを開き，`git clone`コマンドを実行してクローンする．

```bash
git clone <URL>
```

- [GitLabでのリポジトリ複製方法](https://docs.gitlab.com/topics/git/clone/)
- [GitHubでのリポジトリ複製方法](https://docs.github.com/ja/repositories/creating-and-managing-repositories/cloning-a-repository?tool=webui#about-cloning-a-repository)

### 補足

SSHでクローンするためには，事前に作業するマシン内でSSHキーを作成し，GitHubやGitLabにSSHキーを登録しておく必要がある．登録方法は以下のURLが参考になる．

- [GitLab SSHキー登録](https://gitlab-docs.creationline.com/ee/user/ssh.html#generate-an-ssh-key-pair)
- [GitHub SSHキー登録](https://docs.github.com/ja/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux)

---

## ブランチ作成 ~ プッシュ

新しい機能を開発をする時やバグを直す時など，何か作業をする時はブランチを作ってから作業を始める．ブランチの命名規則はチームで運用されているブランチ戦略によって，チームのルールを決めると良い．

ブランチはGitHub/GitLabのリモートリポジトリ上でも，ローカルのリポジトリ上でも可能である．リモートリポジトリ上で作成した場合，ローカルリポジトリへブランチをpullする必要がある．ローカルリポジトリで作成した場合，リモートリポジトリへpushする場合，少し工夫が必要になる，

### リモートリポジトリでブランチを作成する場合

1. GitHub/GitLab上でブランチを作成する
2. ローカルリポジトリにブランチをpullする
   1. `git pull <ブランチ名>`
3. 作業ブランチにコミットする
4. 作業完了後，リモートリポジトリへプッシュする
   1. `git push origin <ブランチ名>`

### ローカルリポジトリでブランチを作成する

0. mainブランチを最新にする
1. `main`ブランチから作業ブランチを作成する
   1. `git branch ブランチ名`
2. 作業ブランチに移動する
   1. `git switch ブランチ名`
3. 作業を行い，コミットする
4. リモートリポジトリへプッシュする
   1. `git push -u origin ブランチ名`

### ブランチ名の命名規則の例

- `feature/機能名`: 新機能開発
- `fix/バグ名`: バグ修正
- `docs/ドキュメント名`: ドキュメント更新
- `refactor/作業名`: リファクタリング

### コミットメッセージのベストプラクティス

- 簡潔で明確な説明
- 何を「なぜ」変更したかを記述
- 50文字以内の要約から始める

---

# チーム開発: レビューを行う

## Pull Request（プルリクエスト）の作成

1. GitHubでPull Requestを作成
2. 変更内容の説明を記載
3. レビュアーを指定
4. 必要に応じてラベルやマイルストーンを設定

## コードレビューのポイント

- **機能性**：コードが意図した通りに動作するか
- **可読性**：他の開発者が理解しやすいか
- **保守性**：将来の変更に対応しやすいか
- **テスト**：適切なテストが含まれているか

---

# チーム開発: マージする

## マージの方法

### 1. Merge Commit（マージコミット）

```bash
git checkout main
git merge feature/new-function
```

- すべての履歴が保持される
- マージコミットが作成される

### 2. Squash and Merge

- featureブランチのコミットを1つにまとめる
- 履歴がシンプルになる

### 3. Rebase and Merge

- 線形な履歴を保つ
- マージコミットが作成されない

---

# チーム開発: 変更履歴を取り込む

```bash
# mainブランチに移動
git checkout main

# リモートの最新変更を取得
git pull origin main

# または fetch + merge
git fetch origin
git merge origin/main
```

## ブランチの削除

```bash
# ローカルブランチの削除
git branch -d feature/new-function

# リモートブランチの削除
git push origin --delete feature/new-function
```

---
