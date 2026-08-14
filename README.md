# LintLLM: An Open-Source Verilog Linting Framework Based on Large Language Models

[![Paper](https://img.shields.io/badge/GLSVLSI%2725-Paper-blue)](https://doi.org/10.1145/3716368.3735198)

LintLLM is an **open-source Verilog linting framework** powered by Large Language Models (LLMs). It aims to detect potential defects in Verilog RTL designs with higher accuracy and lower false positives than traditional EDA tools. The framework also introduces a **high-quality benchmark** with 90 Verilog designs and 11 categories of injected defects.

## 🔥 Highlights

- 📌 Linting framework based on LLMs for static code analysis.
- 🌲 Proposes **Prompt of Logic-Tree**, a novel prompt template to guide LLM reasoning.
- 🧭 Introduces **Defect Tracker**, which reduces false positives by identifying root defects.
- 🧪 Includes a **benchmark** with 90 Verilog modules across 3 difficulty levels.
- 💰 Achieves better accuracy than commercial tools at **<1/10** of the cost.

## 🏗️ Components

### 1. Prompt of Logic-Tree
A structured prompting method that guides LLMs through tree-based logical reasoning, helping them better interpret and detect code defects.

### 2. Defect Tracker
A three-step algorithm that identifies **root defects** responsible for **multiple secondary issues**, significantly reducing redundancy in LLM outputs.

### 3. Verilog Defect Benchmark
- Total: 90 modules
- 11 defect types (e.g., signal usage, port type, logic synthesis issues)
- Categorized into:
  - ✅ Simple (30)
  - ✅ Medium (30)
  - ✅ Complex (30)

## 📊 Results Summary
| Tool                  | Correct Rate ↑ | False Positive ↓ |
| --------------------- | -------------- | ---------------- |
| Commercial EDA        | 64.44%         | 27.78%           |
| Verilator             | 62.22%         | 32.22%           |
| **o1-mini + LintLLM** | **83.33%**     | **12.22%**       |

## 💸 Cost Analysis
- Detecting 1 million lines with LLMs ≈ $20
- ⚡ LLMs offer a scalable and cost-effective alternative for SMEs and academia.

## 📜 License
This project is open-sourced under the MIT License.

## 🧠 Paper

This work was published at [GLSVLSI 2025](https://doi.org/10.1145/3716368.3735198). [arXiv](https://arxiv.org/abs/2502.10815)

## Citation
If LintLLM could help your project, please cite our work:
```
@inproceedings{Fang2025lintllm,
  author={Zhigang Fang and Renzhi Chen and Zhijie Yang and Yang Guo and Huadong Dai and Lei Wang},
  booktitle={Proceedings of the Great Lakes Symposium on {VLSI} 2025, {GLSVLSI} 2025, New Orleans, LA, USA, June 30-July 2, 2025}, 
  title={{LintLLM}: An Open-Source Verilog Linting Framework Based on Large Language Models}, 
  year={2025},
  publisher={ACM},
  url={https://doi.org/10.1145/3716368.3735198}
  }
