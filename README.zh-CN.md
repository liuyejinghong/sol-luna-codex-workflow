# Codex 的 Sol + Luna 工作流

**Sol 负责消化模糊性，Luna Max 负责边界明确的执行，第一性原理约束则让验证始终服务于结果。**

这个仓库既是一份供人阅读的工作流，也是一套可以直接交给 Agent 部署的 Codex 配置。GPT-5.6 Sol 留在主线程，负责理解目标、拆分任务、处理权衡、检查结果和整合最终输出；具名的 GPT-5.6 Luna Max worker 负责代码审查、模块分析、独立实现、测试排查等可以封装成完整执行包的任务。

[English](README.md)

```text
Sol 主线程：目标 -> 边界 -> 执行包 -> 验收 -> 整合
                              |
                              v
Luna Max：检查 / 分析 / 实现 / 排查 / 回传
```

## 编排逻辑放在哪里

任务拆解逻辑属于 Skill，不属于 worker 配置。三层配置各自只承担一种职责：

| 层级 | 职责 |
|---|---|
| [`personalization.md`](personalization.md) | 在 Codex App 中启用这套偏好，并告诉 Sol 何时进入该工作流 |
| [`sol-luna-workflow`](skills/sol-luna-workflow/SKILL.md) | 定义 Sol 的任务拆解判断、路由、执行包、写入隔离、验证、验收和整合流程 |
| [`luna-worker.toml`](agents/luna-worker.toml) | 固定 Luna Max 执行通道，并禁止 worker 重新定义任务或自行扩大范围 |

Sol 先锁定整体目标、不可变事实、验收标准和授权边界，把模糊判断与跨任务决策留在主线程。只有能够独立完成、客观验收、写入范围不重叠的结果单元，才会被封装成执行包交给 Luna。Luna 执行后，Sol 再按照整体任务合同检查证据、处理冲突并整合结果。

这是一套社区工作流，不是 OpenAI 官方预设。模型可用性、实际路由和最终权限会受到 Codex 版本与账号影响。仓库里的自定义 Agent 格式已于 2026-08-02 对照官方 [Codex 子代理文档](https://developers.openai.com/codex/agent-configuration/subagents)和配置 Schema 检查，并使用 Codex App `26.727.51351` 及其内置 CLI `0.146.0-alpha.9.2` 完成解析和加载验证；安装后仍应通过一次真实委派核对实际模型路由。

## 为什么这样编排

主代理和 worker 承担的是两种不同工作。Sol 保留完整目标，以及需要广泛上下文才能判断的模糊问题。Luna 接收一个压缩后的执行包，其中只有一个目标、拥有的文件、明确的不做事项、验收标准、验证方式和停止条件。这样既能减少主线程的上下文污染，也能防止能力更小的 worker 在执行过程中偷偷重新定义问题。

当前 [DeepSWE v1.1 成本榜](https://deepswe.datacurve.ai/)可以说明为什么 Luna Max 很适合 worker 通道。在 2026-07-25 更新的榜单快照中，Luna Max 得分 67%，单任务平均报告成本为 0.61 美元，在这项基准上呈现了很突出的成本与效果平衡。这不等于 Luna Max 在所有仓库和任务上都绝对最优。

[![DeepSWE v1.1 成本榜：Luna Max 得分 67%，平均成本 0.61 美元](docs/assets/deepswe-v1.1-cost-leaderboard.png)](https://deepswe.datacurve.ai/)

低成本 worker 也有代价。Luna 不适合直接承担模糊目标、持续变化的需求、全局架构判断，或者需要在执行中不断发现真实边界的任务。[`sol-luna-workflow` Skill](skills/sol-luna-workflow/SKILL.md) 的作用，就是把这个限制变成明确流程：Sol 先把模糊问题压缩成边界清晰的执行包，Luna 完成执行，最后由 Sol 检查和整合。

这是一套已经选定的默认拓扑，不需要为每个任务重新做一次模型选型。子任务满足委派合同后，Sol 可以直接调用具名的 Luna Max worker，无需重新比较 Luna Medium、Terra 或其他档位，也无需再次询问用户。例外来自任务结构本身：目标模糊、共享可变状态、写入范围重叠，或者动作没有获得授权。

并行只是可选手段。只有上下文彼此独立、写入范围不重叠时才有价值。顺序依赖、共享状态、架构与最终判断、发版和其他外部副作用，默认仍留在 Sol，除非用户对某个更窄的动作给出明确授权。

## 第一性原理红线

模型能力越强，越容易生成抽象、测试、审查器和工具；同一种能力也可能让“自审自测”的边界远远超过原始任务。这个工作流来自一次真实复盘：一个很小的任务持续了五个多小时，其中真正改变目标行为的工作大约只有四十分钟，其余大部分时间都耗在打磨测试、建设验证工具、修复工具自身瑕疵，再验证这些修复。

结论不是“少测试”，而是代码、测试和工具链都必须用业务结果证明自己的必要性。增加任何测试、gate、dry-run、审查或工具前，都要先回答三个问题：

```text
它保护什么具体且不可逆的风险？
如果失败，会改变什么决策？
为什么现有的更便宜证据不足？
```

默认验证合同是“一次聚焦合同检查 + 一次真实链路结果核对”。如果验证成本已经超过实现本身，或者连续两个步骤都只是在修验证层或工具链、没有增加任何关于原始目标的业务事实，就应停止扩张工具链，回到根问题。

## 仓库内容

| 路径 | 用途 |
|---|---|
| [`agents/luna-worker.toml`](agents/luna-worker.toml) | 具名的 Luna Max worker 配置 |
| [`skills/sol-luna-workflow/SKILL.md`](skills/sol-luna-workflow/SKILL.md) | Sol 的拆解、委派、验收、整合和验证策略 |
| [`personalization.md`](personalization.md) | 供人工粘贴到 Codex App 的中英文个性化提示词 |
| [`scripts/install.sh`](scripts/install.sh) | 遇到冲突不覆盖的安全安装脚本 |
| [`AGENTS.md`](AGENTS.md) | Agent 读取这个仓库时遵循的部署合同 |

## 直接把仓库交给 Agent

把仓库地址和下面这段话发给 Codex Agent：

```text
请为我的 Codex 用户配置安装 https://github.com/liuyejinghong/sol-luna-codex-workflow 。
遵守仓库里的 AGENTS.md，保留我现有的全部 Codex 配置，遇到冲突不要覆盖；
安装后验证 Agent 和 Skill，并向我说明 Codex App 个性化提示词的人工操作步骤。
```

仓库的部署合同只允许安装 Agent 写入以下两个目标：

```text
~/.codex/agents/luna-worker.toml
~/.codex/skills/sol-luna-workflow/SKILL.md
```

如果任一目标已经存在且内容不同，安装脚本会在写入任何文件之前退出。它不会修改 `config.toml`、其他 Agent 或 Skill、全局 `~/.codex/AGENTS.md`，也不会修改 Codex App 的账号设置。

## 自己安装

```bash
git clone https://github.com/liuyejinghong/sol-luna-codex-workflow.git
cd sol-luna-codex-workflow
bash scripts/install.sh
```

如果设置了 `CODEX_HOME`，安装脚本会使用它；否则使用 `~/.codex`。文件内容相同时可以安全重复执行。

然后打开 Codex App 的「设置 → 个性化 → 自定义指令」，从 [`personalization.md`](personalization.md) 中选择一种语言，完整粘贴对应代码块。新建一个任务测试工作流。修改个性化提示词通常不需要重启；只有新 Agent 没有被发现时，才需要重开 Codex 再试。

## 个性化提示词必须人工粘贴

`personalization.md` 只是可复制的文档，不是会自动生效的配置。把它放在 GitHub 上，不等于已经粘贴进 Codex App。OpenAI 把 Custom Instructions 定义为通过设置界面管理的账号偏好，而 `AGENTS.md` 属于 Codex 每次运行时读取的指令链。两者目的有重叠，但不是同一个配置入口。可参考官方的 [Custom Instructions 说明](https://help.openai.com/en/articles/8096356-chat-preferences-for-chatgpt)和 [Codex `AGENTS.md` 指南](https://developers.openai.com/codex/guides/agents-md)。

把相同内容写入 `~/.codex/AGENTS.md`，可以为 Codex 会话提供近似的全局规则，但它不完全等价于 App 个性化提示词，而且项目级指令仍可能覆盖它。安装脚本因此不会碰这两个入口。若目标是让 Codex App 的账号级个性化生效，目前仍需要人工粘贴。

## Luna 执行包

Sol 只向 worker 提供完成任务所需的事实：

```text
目标：
范围和拥有的路径：
必要事实：
不做事项：
验收标准：
验证方式：
停止条件：
回传格式：
```

任务无法在执行包内完成时，Luna 应回传准确阻塞点，而不是自行扩大范围。Sol 检查交接结果，并继续承担最终项目判断。

## 只验证一次

选择一个答案明确、只读的小任务，让 Sol 委派给 `luna_worker`。如果客户端显示子代理元数据，核对模型为 `gpt-5.6-luna`、推理强度为 `max`、结果没有越界，也没有无关写入。模型自称“我是 Luna”不能证明实际路由。Codex 客户端大版本更新或实际路由出现变化后，再做一次相同检查即可。

## 官方资料

| 主题 | 来源 |
|---|---|
| Codex 子代理和自定义 Agent | [OpenAI Developers](https://developers.openai.com/codex/agent-configuration/subagents) |
| Codex 指令发现顺序 | [OpenAI Developers](https://developers.openai.com/codex/guides/agents-md) |
| Custom Instructions | [OpenAI Help Center](https://help.openai.com/en/articles/8096356-chat-preferences-for-chatgpt) |
| Codex 配置 Schema | [OpenAI Developers](https://developers.openai.com/codex/config-schema.json) |
| DeepSWE v1.1 榜单 | [DataCurve](https://deepswe.datacurve.ai/) |
