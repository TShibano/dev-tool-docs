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
初版: 2025/08/05<br>
更新日: 2025/08/05<br>
</div>

---

# はじめに

## 想定読者

- Gitを使って個人開発でバージョン管理を行っている人

## 本資料のゴール

- Gitで以下の応用的な使い方ができる
  - 管理対象のファイルを選択する
  - タグ付け
  - コミットの整理
  -

## この資料で説明しないこと

- Gitの基本的な内容

---

# Gitの便利機能

ここからはGitを使う上で発展的な便利機能を紹介する．

- `.gitignore`による管理対象ファイルの選択
- タグ付け
- Gitエイリアス設定
- `git stash`
- `git rebase`
- `git cherry-pick`
- `git blame`

### .gitignore

`.gitignore`を用いることで管理対象外にするファイルを指定できる．
`.gitignore`ファイルは，リポジトリが存在するワークディレクトリ内であればどの場所においても良く，`.gitignore`ファイルからの相対パスを用いてファイルを指定する．

```
# #以下はコメントになる
memo.txt
# アスタリスクなどを使用して，指定することもできる．
*.log     # .logと付くファイル全てを指定する
# ディレクトリを指定することも可能
node_modules/
```

### タグ付け

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

### Gitエイリアス設定

```bash
# よく使うコマンドを短縮
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
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

## コミットの整理

一度コミットした履歴は整理することができる．コミットを整理することで以下の利点がある．

- プロジェクトの変更履歴を理解しやすくする
- コードレビューの効率を向上させる
- バグの原因特定を容易にする
- チーム開発における協力を円滑にする

ただし，すでにリモートリポジトリにプッシュしたコミットは他の人に影響を与える可能性があるため，コミットの整理はチームで相談した上で判断する．

### インタラクティブリベース

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
