# Codex 的 Sol + Luna 工作流

让 **GPT-5.6 Sol** 留在主线程担任负责人，将边界明确、可以独立完成的任务交给具名的
**Luna Max** worker。Sol 始终负责拆解、验收、整合和最终输出。

[English](README.md)

```text
Sol 主线程：理解目标 -> 拆分 -> 委派 -> 检查 -> 整合
                              |
                              v
Luna Max：代码审查 / 模块分析 / 独立实现 / 测试排查
```

这是一个社区工作流，不是 OpenAI 官方预设。自定义 Agent 的路由和模型可用性可能因 Codex
客户端、版本和账号而不同。安装后应验证实际 worker 模型，不能只相信提示词或配置文件。

兼容性快照：仓库中的 TOML 结构已在 2026-08-02 按官方 Codex 自定义 Agent 文档和配置
Schema 核对。模型权限和最终运行权限仍取决于具体客户端与账号。

## 为什么这样设计

- Sol 保留完整目标、权衡和最终决策。
- Luna 接收压缩后的执行包，完成任务后只返回精简交接。
- 独立上下文可以避免探索过程和测试输出污染主线程。
- 并行不是默认目标，只用于范围独立且写入不重叠的任务。

## 安装

克隆仓库后，把 Agent 和 Skill 复制到 Codex 全局配置目录：

```bash
mkdir -p ~/.codex/agents ~/.codex/skills/sol-luna-workflow
cp agents/luna-worker.toml ~/.codex/agents/luna-worker.toml
cp skills/sol-luna-workflow/SKILL.md ~/.codex/skills/sol-luna-workflow/SKILL.md
```

从 [`personalization.md`](personalization.md) 复制中文或英文版本，粘贴到 Codex 的
「设置 -> 个性化 -> 自定义指令」。

新建任务进行首次测试最干净。修改个性化提示词通常不需要重启；如果新增的自定义 Agent
没有被发现，可以重开 Codex 后再测试一次。

## 适合委派的任务

- 范围明确的代码审查；
- 模块或依赖分析；
- 已指定写入路径的独立实现；
- 聚焦的测试失败排查；
- 有客观验收条件的盘点、提取、转换或文档任务。

以下内容留在 Sol：

- 修改整体目标或架构；
- 优先级和最终权衡；
- 顺序依赖或共享状态任务；
- 写入范围重叠的任务；
- 发版、生产、账号或其他外部变更，除非用户明确授权。

## 委派执行包

只向 worker 提供必要信息：

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

Sol 应检查并整合 Luna 的结果。worker 的交接不等于最终项目结论。

## 可选 Fast 模式

仓库中的默认配置没有开启 Fast。需要更低延迟时，可以增加：

```toml
service_tier = "fast"
```

Fast 可能按更高额度或价格计费，也不保证每个使用界面都支持。它是延迟选择，不是必然的
成本优化。

## 一次性验证

选择一个结果明显、只读的小任务，让 Sol 委派给 `luna_worker`。在界面支持的情况下，检查
子代理卡片或运行元数据：

- 模型为 `gpt-5.6-luna`；
- 推理强度为 `max`；
- 返回了预期的边界内结果；
- 没有产生无关写入。

不要把模型自己声称「我是 Luna」当作路由证据。Codex 大版本更新或路由行为变化后，再做一次
相同检查即可。主线程的实时权限覆盖仍可能收紧自定义 Agent 配置的 sandbox。

## 官方资料

- [Codex 子代理](https://developers.openai.com/codex/agent-configuration/subagents)
- [GPT-5.6 模型指南](https://developers.openai.com/api/docs/guides/latest-model)
- [Fast 模式](https://developers.openai.com/api/docs/guides/fast-mode)
- [Codex 配置 Schema](https://developers.openai.com/codex/config-schema.json)
