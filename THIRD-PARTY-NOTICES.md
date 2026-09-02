# 第三方授權聲明

本倉庫的 `skills/` 底下有部分 skill 來自第三方開源專案，以下保留其原始授權條文與
著作權聲明。其餘 skill（`verify-before-trust`、`feature-batch-workflow`、
`data-source-verification`）為本倉庫作者自行撰寫。

---

## keez97/claude-architecture-skills

來源：https://github.com/keez97/claude-architecture-skills

涵蓋以下 skill：

- `architecture-workflow`（本倉庫已修改：Phase 3 由 `tdd-ai` 改指向 `feature-batch-workflow`）
- `cloud-infrastructure`
- `describe-design`（本倉庫已修改：description 補上與 `codebase-analysis` 的分流條件）
- `microservices-architect`
- `modern-web-app-architecture`
- `python-architecture-review`
- `software-architecture`

```
MIT License

Copyright (c) 2026 keez97

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Ycsyyds/codebase-analysis-skill

來源：https://github.com/Ycsyyds/codebase-analysis-skill

涵蓋以下 skill：

- `codebase-analysis`（本倉庫已修改：description 補上與 `describe-design` 的分流條件，
  並註明 Phase 0 會自動執行 /init 的副作用）

原始授權條文另存於 `skills/codebase-analysis/LICENSE`，內容為：

```
MIT License

Copyright (c) 2026 codebase-analysis contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
