---
marp: true
theme: a4-document
paginate: true
---

<!-- class:  title-page -->

<div class="title">
    Git応用編
</div>

<div class="meta">
citrus88<br>
citrus.mikan88@gmail.com<br>
初版: 2025/08/28<br>
更新日: 2025/08/28<br>
</div>

---

# はじめに

## 想定読者

- Gitの基本的な使い方は理解している人

## 本資料のゴール

Gitで以下の応用的な使い方ができる

- エイリアス設定
  - `git config --global alias.`
- 管理対象のファイルを選択する
  - `.gitignore`ファイル
- タグ付け
  - `git tag`
- 作業中の変更を一時的に退避する
  - `git stash`
- コミットする範囲を指定する
  - `git add -p`
- コミットの整理
  - `git rebase -i`
  - `git reset --soft`
- 別ブランチにある特定のコミットを適用する
  - `git cherry-pick`
- 行単位の変更履歴の確認
  - `git blame`

## この資料で説明しないこと

- Gitの基本的な内容

---

## Gitエイリアス設定

エイリアスとは，コマンドなどを短縮するために用いる機能である．

`git config --global alias.<省略名> <コマンド>`という構文で設定することができる．

```bash
# エイリアス例
# 設定したエイリアスを確認する
git config --global alias.al "config --get-regexp ^alias\."
# 変更状態を確認するコマンド
git config --global alias.st status
# 変更履歴をグラフで可視化するコマンド
# `git lg -5` などとすることで，上位5つまでの履歴を確認できる
git config --global alias.lg "log --oneline --graph"
```

---

## 管理対象のファイルを選択する

`.gitignore`を用いることで管理対象外にするファイルを指定できる．
`.gitignore`ファイルは，リポジトリが存在するワークディレクトリ内であればどの場所においても良く，`.gitignore`ファイルからの相対パスを用いてファイルを指定する．
`.gitignore`ファイルの描き方にはブラックリスト方式とホワイト方式リストの2種類がある．
ブラックリスト方式は除外したい対象を記載する方法である．
一方でホワイトリスト方式は，一旦すべてのファイルとディレクトリを除外し，その後管理対象を明示的に指定する方法である．

### ブラックリスト方式による管理対象の除外

```.gitignore
# ブラックリスト方式で，追跡対象から除外する
memo.txt
# アスタリスクなどを使用して，指定することもできる．
*.log     # .logと付くファイル全てを指定する
# ディレクトリを指定することも可能
node_modules/
```

### ホワイトリスト方式による明示的な管理対象の指定

```.gitignore
# ホワイトリスト方式で，管理対象を明示的に記載する
# すべてを管理対象から外す
*
# すべてのディレクトリを管理対象に戻す
!*/
# 管理対象を記載する
!.gitignore    # .gitignoreを管理対象に戻す
!*.py    # すべてのPythonファイルを管理対象に戻す
# 管理対象から除外したい場合は，再度記述する
/build    # buildディレクトリをやっぱり管理対象から除外する
```

### コミット後の管理対象の指定

すでにコミットしているファイルを後から除外したい場合，以下の対応を行う．
なお， `git rm --cached`を行ってもファイルは自体は消えない．
ただし，チームで開発している場合，事前に確認・調整が必要である．

#### ファイルが少量の場合

```shell
# .gitignoreにファイル・ディレクトリを追加
git rm --cached <ファイル名>
git rm -r --cached <ディレクトリ名>
git add .gitignore
git commit -m "remove files from tracking and add to .gitignore"
```

#### ファイルが大量にある場合

```shell
# .gitignoreにファイル・ディレクトリを追加
# .gitignoreパターンに一致するファイルを一括削除
git ls-files -i c --exclude-standard | xargs git rm --cached
git add .gitignore
git commit -m "remove files from tracking and add to .gitignore"
```

---

## タグ付け

GitではコミットIDでバージョン管理を行うが，コミットIDはSHA-1形式で人間にとって読みにくいので，タグを付与することができる．
例えば，リリースバージョンにはv1.0.0やv2.0.0のようにバージョン番号を付与することができる．

```bash
# 軽量タグの作成
git tag v1.0.0

# 注釈付きタグの作成
git tag -a v1.0.0 -m "リリース版 1.0.0"

# タグをリモートにプッシュ
git push origin v1.0.0

# すべてのタグをプッシュ
git push origin --tags
```

---

## 作業中の変更を一時的に退避する(`git stash`)

`git stash`を使うことで作業中の変更を一時的に退避することができる．

例えば以下のような場面で使用する．

- 緊急のバグ修正で別ブランチに切り替える必要がある
- Pull前に未コミットの変更がある

```bash
# 変更を退避
git stash

# メッセージ付きで退避
git stash push -m "作業中の変更を一時保存"

# 退避した変更を戻す
git stash pop

# 退避リストを確認
git stash list

# 特定の stash を適用
git stash apply stash@{0}
```

---

## コミットする範囲を指定する

一度に多くの箇所を変更してしまった場合，分割してコミットすることができる．
その方法は， `git add -p` を用いてステージングエリアに追加する範囲を指定する方法である．

```shell
git add -p
# 編集画面が出るので操作する
git commit -m "コミット1"
git add -p
# 編集画面が出るので操作する
git commit -m "コミット2"
```

`git add -p`を用いた時の操作方法は以下の通りである．

- `y` を入力すると変更をステージングエリアに追加する
- `n` を入力すると変更をステージングエリアに追加しない
- `s` を入力すると変更を分割してステージングエリアに追加する
- `e` を入力すると変更を編集する
- `q` を入力すると変更をステージングエリアに追加しない

---

## コミットの整理

一度コミットした履歴は整理することができる．コミットを整理することで以下の利点がある．

- プロジェクトの変更履歴を理解しやすくする
- コードレビューの効率を向上させる
- バグの原因特定を容易にする
- チーム開発における協力を円滑にする

ただし，すでにリモートリポジトリにプッシュしたコミットは他の人に影響を与える可能性があるため，コミットの整理はチームで相談した上で判断する．

### 既存のコミット履歴を少し変更したい場合

```bash
# インタラクティブリベース
git rebase -i HEAD~3

# 別ブランチにリベース
git rebase main

# リベース中止
git rebase --abort

# リベース継続
git rebase --continue
```

### コミット履歴を大幅に変更したい場合

```shell
git reset --soft HEAD~N    # 遡りたいコミットまで指定し，コミットを削除
git reset # すれージングエリアを削除
# 以下2つのコマンドを繰り返す
git add -p # 必要な部分のみステージングエリアに追加
git commit -m "新しいコミットメッセージ"
```

---

## 特定にコミットを別ブランチに適用する(`git cherry-pick`)

`git cherry-pick`を行うことで，特定のコミットを別ブランチに適用することができる．
例えば，特定のバグ修正をブランチに適用したり，リリースブランチに必要な機能のみを選択的に適用したりする時に使用できる．

```bash
# 特定のコミットを現在のブランチに適用
git cherry-pick <commit-hash>

# 複数のコミットを適用
git cherry-pick <commit1> <commit2>

# コミット作成せずに変更のみ適用
git cherry-pick --no-commit <commit-hash>
```

---

## 行単位の変更履歴の確認(`git blame`)

`git blame`を用いることで，行単位の変更履歴を確認することができる．
より詳細に変更履歴を確認したい場合に用いる．

```bash
# ファイル全体の blame
git blame filename.txt

# 特定の行範囲
git blame -L 10,20 filename.txt

# より詳細な情報
git blame -w -C filename.txt
```

---

## まとめ

- Gitを使ってチーム開発行うには，チームの運用ルールを守ることが重要である．
- 応用コマンドでさらに効率的な開発を進めることができる．

---
