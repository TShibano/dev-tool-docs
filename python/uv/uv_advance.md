## 4.4 ワークスペース管理

ワークスペースとは，1つのプロジェクト内に複数のサブプロジェクトをまとめて管理する機能である．Rustなどでも採用されている機能である．
複数のサブプロジェクトに分けることで，それぞれの役割を明確に分離でき，さらに各サブプロジェクト内の依存関係を切り分けることができる．またサブプロジェクトに分けておくことで，それぞれの再利用性も高めることができたり，テストを効率的に行えるようになる．

例えば以下のようなワークスペースの構成を考えてみる．

```
workspace-root/
├── pyproject.toml
├── uv.lock
├── webapp/
│   └── package2/
├── webapp/
│   └── package2/
├── webapp/
│   └── package2/
│   └── package2/
│       ├── pyproject.toml
│       └── src/
```

```toml
# workspace root のpyproject.toml
[tool.uv.workspace]
members = ["webapp", "cli_tool", "common_lib"]
```
