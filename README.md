# Refactoring version of 《FPGA应用开发和仿真》

## Overview

**Purpose**:
This repository is dedicated to refactoring the codebase to improve its structure and modularity.
The original code is written primarily for publication without a good coding style.
After learning the book and using the code for development, I decide to organize the code for better maintainability and re-usability.

**Key Feature:**
- Avoid using behavior description. Only implement DFF with enable and clear in `always` block. RTL codes describe what circuit looks like.
- Reorganized Code into logical modules for better separation of concerns. One Module in one file. And better file hierarchy.
- Modify the code to be synthesizable for both FPGA and ASIC.
- Replace synchronous reset with asynchronous `rst_n`.
- `Verible` formatter and `Verilator` linting. Compilation commands using `iverilog` in Linux. The  current used `iverilog` binary is built from source on 12, Dec, 2024.
- Comments on the compiler or platform dependency.

**Status**:
This branch is under active development. You are welcomed to follow and contribute.
More details or the principle of digital design can be referred to this book.

## Coding Notes

This section will cover some usage of `SystemVerilog` syntax of concern.

### `initial`

`initial` block or declaration initial assignment is note supported in synthesis for ASIC while some FPGA tools may support them.


### `task`

For `task` is not supported in `iverilog`, the initialization of `clk` and `rst_n` is replaced using `initial` block.

### Combinational circular in `AccuM.sv`

### `$random`

According to <a href="https://github.com/chipsalliance/verible/issues/2221">an issue under Verible</a>, it's recommended to use `$urandom` instead of `$random`.
However, I cannot vouch for the absolute accuracy by now.
This is the answer given by AI, maybe serving as a reference:

关于您提到的 `$random` 和 `$dist_*` 函数在 Verible 中被视为禁止使用的系统函数或任务的问题，这个规定来自于 Verible 的代码风格检查规则。根据芯片联盟（chipsalliance）的 Verible 项目在 GitHub 上的 Issue #2221 中的讨论，Verible 鼓励使用 `$urandom` 或 `randomize()` 替代 `$random` 和 `$dist_*` 函数。这是因为 `$random` 和 `$dist_*` 函数不是 SystemVerilog 随机稳定性模型的一部分，并且可能会破坏仿真的可重现性。

以下是一些关键点和参考资料：

1. **随机稳定性（Random Stability）**：在 SystemVerilog 中，随机稳定性是指不同线程随机值各自独立，以及当代码出现微小改动时随机值还是稳定的。`$urandom`、`$urandom_range` 和 `randomize()` 等函数都保证了随机稳定性。

2. **为什么避免使用 `$random` 和 `$dist_*`**：`$random` 函数使用的算法可能不够复杂，并且在不同的仿真器之间可能无法保证随机数生成的一致性。而 `$urandom` 和 `randomize()` 函数提供了更好的随机数生成器，它们通常基于硬件随机数生成器或操作系统提供的加密安全随机数生成器，因此生成的随机数序列是不可预测的，并且具有更高的安全性。

3. **替代方案**：Verible 推荐使用 `$urandom` 或 `randomize()` 替代 `$random` 和 `$dist_*`。`$urandom` 函数生成的是加密安全的随机数，而 `randomize()` 函数是对象随机化方法，可以对类成员变量执行专有的随机化操作。

4. **线程和对象的随机数生成**：在 SystemVerilog 中，每个进程（包括线程、对象、函数或任务调用）都有一个独立的随机数生成器（RNG）。了解这一点对于开发测试平台时控制随机数生成非常重要。

综上所述，为了确保仿真的可重现性和随机数生成的稳定性，Verible 建议使用 `$urandom` 或 `randomize()` 替代 `$random` 和 `$dist_*` 函数。这些替代方案提供了更好的随机数生成器，并且更符合 SystemVerilog 的随机稳定性模型。


## Coding style

The below lists several coding style I adhere to.

### Basic

#### 1. Name

#### 2. Format

#### 3. Design

##### Signal Definition


a. All the signal are defined as `logic` type.


##### Data Width and Constant values

a. MSB : LSB
b. LSB starts with 0, except address alignment


- Packed Array

Using packed array instead.

```verilog
logic [3 : 0][7 : 0] data; // packed array
```
#### 4. Simulation

### Advanced

### Special

### Tools

## Simulation Guide

This repository adds a definitive (try my best) guide for simulation.
I believe the basic tools and infrastructure for design and simulation is vital because it can make the process of development and debugging faster.

## Illustration

The major content in this repository are the source code and errata for the book *FPGA Application Development and Simulation* (CHS, ISBN:9787111582786). After the publication of the book, some bug fixes, code optimizations and other related content have been added one after another.

All modules are synthesizable, EXCEPT:

1. Modules for testbenches;
2. Most FPGA development tools do not support the `let` construct, which can be converted to `task`;
3. Some FPGA development tools (e.g., old versions of Quartus) do not support the evaluation of real parameter expressions, you may calculate and replace them by yourself.

