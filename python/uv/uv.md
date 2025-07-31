---
marp: true
theme: ../../style/slide.css
---

# uvパッケージ管理ツール ガイドドキュメント

## 1. uvとは

uvは、Rustで書かれた高性能なPythonパッケージおよびプロジェクト管理ツールです。pip、pip-tools、pipx、poetry、pyenv、twine、virtualenvなどの複数のツールを1つで置き換える包括的なソリューションとして設計されています。

## 2. uvの特徴・メリット

### 2.1 高速性

従来のpipなどのPythonパッケージ管理ツールと比較して、大幅な速度改善を実現しています。Rustで書かれているため、極めて高速な処理が可能です。

### 2.2 信頼性

依存関係解決の信頼性が向上しており、より一貫性のある環境構築が可能です。

### 2.3 統合性

複数のPythonツールを1つに統合することで、ツールチェーンの複雑さを大幅に軽減します。

### 2.4 Python自動管理

必要に応じて不足しているPythonバージョンを自動的にインストールし、Python環境のセットアップを簡素化します。

## 3. uvができること・他のツールとの差異

### 3.1 主な機能

- **パッケージ管理**: pip、pip-toolsの代替
- **仮想環境管理**: virtualenvの代替
- **プロジェクト管理**: poetryの代替
- **Pythonバージョン管理**: pyenvの代替
- **ツール実行**: pipxの代替
- **パッケージ公開**: twineの代替

### 3.2 従来ツールとの差異

一般的なpip、pip-tools、virtualenvコマンドのドロップイン置換として設計されており、学習コストを最小限に抑えながら大幅な性能向上を実現しています。

## 4. uvのインストール方法

### 4.1 基本インストール

#### macOS・Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Windows

```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 4.2 パッケージマネージャーでのインストール

#### Homebrew (macOS/Linux)

```bash
brew install uv
```

#### pipx

```bash
pipx install uv
```

### 4.3 インストール確認

```bash
uv --version
```

## 5. uvの基本的な使い方

### 5.1 仮想環境の作成と管理

#### 新しいプロジェクトの初期化

```bash
uv init my-project
cd my-project
```

### 5.2 ライブラリの追加・削除

#### パッケージの追加

```bash
uv add requests
```

#### パッケージの削除

```bash
uv remove requests
```

#### 依存関係のインストール

```bash
uv sync  # pyproject.tomlから依存関係をインストール
```

### 5.3 Pythonスクリプトの実行

#### スクリプトの実行

```bash
uv run python script.py
uv run pytest  # テストの実行
```

#### ワンライナーでのスクリプト実行

```bash
uvx pycowsay "Hello World!"  # 一時的な環境でツールを実行
```

## 6. uvの応用的な使い方

### 6.1 開発環境パッケージの管理

#### 開発依存関係の分離

```bash
# 開発用パッケージの追加
uv add --dev pytest ruff mypy

# プロダクション環境でのインストール（開発依存関係を除外）
uv sync --no-dev
```

#### プロジェクト設定（pyproject.toml）

```toml
[project]
name = "my-project"
version = "0.1.0"
dependencies = [
    "requests>=2.28.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "black>=22.0.0",
    "flake8>=5.0.0",
]
```

### 6.2 他人とのプロジェクト共有方法

#### ロックファイルの生成と共有

uvは自動的に`uv.lock`ファイルを生成し、正確な依存関係バージョンを記録します。

```bash
# プロジェクトのクローン後
git clone <repository>
cd <project>
uv sync  # uv.lockから正確な環境を再現
```

#### Docker環境での使用

```dockerfile
FROM python:3.11-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
COPY . /app
WORKDIR /app
RUN uv sync --frozen --no-cache
```

### 6.3 CI/CD環境での活用

#### GitHub Actionsでの使用例

```yaml
- name: Install uv
  uses: astral-sh/setup-uv@v1

- name: Install dependencies
  run: uv sync

- name: Run tests
  run: uv run pytest
```

## 7. 高度な機能

### 7.1 ワークスペース管理

複数の関連プロジェクトを1つのワークスペースで管理できます。

```toml
# workspace root のpyproject.toml
[tool.uv.workspace]
members = ["packages/*"]
```

### 7.2 Pythonバージョン管理

```bash
# 特定のPythonバージョンのインストール
uv python install 3.11

# プロジェクトでのPythonバージョン指定
uv python pin 3.11
```

### 7.3 ツール管理

```bash
# グローバルツールのインストール
uv tool install ruff
uv tool install black

# インストール済みツールの確認
uv tool list
```

## 8. トラブルシューティング

### 8.1 一般的な問題

- キャッシュクリア: `uv cache clean`
- 詳細ログ: `uv --verbose <command>`
- ヘルプ: `uv help <command>`

### 8.2 移行時の注意点

- 既存のrequirements.txtからの移行: `uv add -r requirements.txt`
- poetry.lockからの移行: プロジェクト再初期化を推奨

## 9. まとめ

uvは「Cargo for Python」を目指す包括的なPythonプロジェクト・パッケージ管理ツールです。高速性、信頼性、使いやすさを兼ね備えており、従来の複数ツールを1つに統合することで、Python開発者の生産性を大幅に向上させます。

モダンなPython開発環境を構築したい開発者、チーム開発でのプロジェクト管理を改善したい組織、CI/CDパフォーマンスを向上させたいプロジェクトにとって、uvは強力な選択肢となるでしょう。

### 出典

- [uv: Python packaging in Rust](https://astral.sh/blog/uv)
- [Python UV: The Ultimate Guide to the Fastest Python Package Manager | DataCamp](https://www.datacamp.com/tutorial/python-uv)
- [Getting started - Astral Docs](https://docs.astral.sh/uv/getting-started/)
- [GitHub - astral-sh/uv](https://github.com/astral-sh/uv)
- [Python UV: The Ultimate Guide to the Fastest Python Package Manager | DataCamp](https://www.datacamp.com/tutorial/python-uv)
- [uv Package Manager for Python | by Dr. Nimrita Koul | Medium](https://medium.com/@nimritakoul01/uv-package-manager-for-python-f92c5a760a1c)
- [Getting help | uv](https://docs.astral.sh/uv/getting-started/help/)
- [Using workspaces | uv](https://docs.astral.sh/uv/concepts/projects/workspaces/)
- [Installing and managing Python | uv](https://docs.astral.sh/uv/guides/install-python/)
- [Using uv in GitHub Actions | uv](https://docs.astral.sh/uv/guides/integration/github/)
- [Using uv in Docker | uv](https://docs.astral.sh/uv/guides/integration/docker/)
- [uv](https://docs.astral.sh/uv/?featured_on=talkpython)
- [Installation | uv](https://docs.astral.sh/uv/getting-started/installation/)
- [uv · PyPI](https://pypi.org/project/uv/0.1.32/)
