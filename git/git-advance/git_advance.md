---
marp: true
theme: default
paginate: true
---

# Git応用編

---

## git mergeの概念

- 複数のブランチの変更を統合
- コンフリクト（競合）が発生する場合もある
- `git merge <branch名>`で実行

---

## git stash

- 作業中の変更を一時退避
- コマンド例：
  - `git stash`：変更を退避
  - `git stash pop`：退避した変更を戻す
- 一時的な作業切り替えに便利

---

## gitのブランチ戦略

- **Git Flow**：開発・リリース・ホットフィックス用のブランチを使い分け
- **GitHub Flow**：main/masterとfeatureブランチのみ
- **Trunk Based Development**：短命なブランチで素早く統合

---

## 付け加えたい内容

- **rebase**：履歴を整理してマージ
  - `git rebase <branch名>`
- **タグ付け**：リリースポイントの記録
  - `git tag <タグ名>`
- **.gitignore**：管理対象外ファイルの指定
- **ログの活用**：`git log --oneline --graph`で履歴を視覚化

---

## まとめ

- 応用コマンドで効率的な開発を
- チームの運用ルールを守ることが重要
- ドキュメントやhelpコマンドを活用

---
