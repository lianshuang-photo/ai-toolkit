# AI Toolkit by Ostris

AI Toolkit 是一个用于扩散模型的一体化训练套件。我尽力在消费级硬件上支持所有最新的模型，包括图像和视频模型。它可以作为 GUI 或 CLI 运行。它的设计目标是易于使用，同时具备所有可想象的功能。

## 支持我的工作

如果您喜欢我的项目或将其用于商业用途，请考虑赞助我。每一点帮助都很重要！💖

[在 GitHub 上赞助](https://github.com/orgs/ostris) | [在 Patreon 上支持](https://www.patreon.com/ostris) | [在 PayPal 上捐赠](https://www.paypal.com/donate/?hosted_button_id=9GEFUKC8T9R9W)

---

## 安装

要求：
- python >3.10
- 具有足够显存的 Nvidia GPU
- python venv
- git

### Linux:
```bash
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
python3 -m venv venv
source venv/bin/activate
# 先安装 torch
pip3 install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu126
pip3 install -r requirements.txt
```

### Windows:

如果您在 Windows 上遇到问题，我建议使用 [https://github.com/Tavris1/AI-Toolkit-Easy-Install](https://github.com/Tavris1/AI-Toolkit-Easy-Install) 的简易安装脚本

```bash
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
python -m venv venv
.\venv\Scripts\activate
pip install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu126
pip install -r requirements.txt
```


# AI Toolkit UI

<img src="https://ostris.com/wp-content/uploads/2025/02/toolkit-ui.jpg" alt="AI Toolkit UI" width="100%">

AI Toolkit UI 是 AI Toolkit 的 Web 界面。它允许您轻松启动、停止和监控任务。它还允许您通过几次点击轻松训练模型。它还允许您为 UI 设置令牌以防止未经授权的访问，因此在暴露的服务器上运行是相对安全的。

## 运行 UI

要求：
- Node.js > 18

UI 不需要持续运行即可运行任务。它仅用于启动/停止/监控任务。以下命令将安装/更新 UI 及其依赖项并启动 UI。

```bash
cd ui
npm run build_and_start
```

您现在可以在 `http://localhost:8675` 或 `http://<your-ip>:8675`（如果在服务器上运行）访问 UI。

## 保护 UI

如果您在云提供商或任何不安全的网络上托管 UI，我强烈建议使用身份验证令牌保护它。
您可以通过将环境变量 `AI_TOOLKIT_AUTH` 设置为超级安全的密码来实现。访问 UI 将需要此令牌。您可以在启动 UI 时这样设置：

```bash
# Linux
AI_TOOLKIT_AUTH=super_secure_password npm run build_and_start

# Windows
set AI_TOOLKIT_AUTH=super_secure_password && npm run build_and_start

# Windows Powershell
$env:AI_TOOLKIT_AUTH="super_secure_password"; npm run build_and_start
```


## FLUX.1 训练

### 教程

要快速入门，请查看 [@araminta_k](https://x.com/araminta_k) 的教程：[在 3090 上微调 Flux Dev](https://www.youtube.com/watch?v=HzGW_Kyermg)，使用 24GB 显存。

### 要求
您目前需要**至少 24GB 显存**的 GPU 来训练 FLUX.1。如果您将其用作控制显示器的 GPU，您可能需要在配置文件的 `model:` 下设置标志 `low_vram: true`。这将在 CPU 上量化模型，应该允许在连接显示器的情况下进行训练。用户已经在 Windows 上使用 WSL 成功运行，但有一些关于在 Windows 原生运行时出现错误的报告。
我目前只在 Linux 上测试过。这仍然是极其实验性的，需要进行大量的量化和技巧才能使其适合 24GB。

### FLUX.1-dev

FLUX.1-dev 具有非商业许可证。这意味着您训练的任何内容都将继承非商业许可证。它也是一个受限模型，因此您需要在使用前在 HF 上接受许可证。否则，这将失败。以下是设置许可证所需的步骤。

1. 登录 HF 并在此处接受模型访问 [black-forest-labs/FLUX.1-dev](https://huggingface.co/black-forest-labs/FLUX.1-dev)
2. 在此文件夹的根目录创建一个名为 `.env` 的文件
3. [从 huggingface 获取 READ 密钥](https://huggingface.co/settings/tokens/new?)并将其添加到 `.env` 文件中，如下所示 `HF_TOKEN=your_key_here`

### FLUX.1-schnell

FLUX.1-schnell 是 Apache 2.0。在其上训练的任何内容都可以按您想要的方式许可，并且不需要 HF_TOKEN 来训练。
但是，它确实需要一个特殊的适配器来训练，[ostris/FLUX.1-schnell-training-adapter](https://huggingface.co/ostris/FLUX.1-schnell-training-adapter)。
它也是高度实验性的。为了获得最佳的整体质量，建议在 FLUX.1-dev 上进行训练。

要使用它，您只需要将助手添加到配置文件的 `model` 部分，如下所示：

```yaml
      model:
        name_or_path: "black-forest-labs/FLUX.1-schnell"
        assistant_lora_path: "ostris/FLUX.1-schnell-training-adapter"
        is_flux: true
        quantize: true
```

您还需要调整采样步骤，因为 schnell 不需要那么多

```yaml
      sample:
        guidance_scale: 1  # schnell 不做引导
        sample_steps: 4  # 1 - 4 效果很好
```


### 训练
1. 将位于 `config/examples/train_lora_flux_24gb.yaml`（对于 schnell 使用 `config/examples/train_lora_flux_schnell_24gb.yaml`）的示例配置文件复制到 `config` 文件夹并将其重命名为 `whatever_you_want.yml`
2. 按照文件中的注释编辑文件
3. 像这样运行文件 `python run.py config/whatever_you_want.yml`

当您启动时，将创建一个具有配置文件中的名称和训练文件夹的文件夹。它将包含所有检查点和图像。您可以随时使用 ctrl+c 停止训练，当您恢复时，它将从最后一个检查点继续。

重要提示：如果您在保存时按 ctrl+c，它可能会损坏该检查点。所以请等到保存完成

### 需要帮助？

除非是代码中的错误，否则请不要打开错误报告。欢迎您[加入我的 Discord](https://discord.gg/VXmU2f5WEU)并在那里寻求帮助。但是，请不要直接向我发送私信询问一般问题或支持。在 Discord 中提问，我会在有空时回答。

## Gradio UI

要使用自定义 UI 在本地开始训练，一旦您按照上述步骤操作并安装了 `ai-toolkit`：

```bash
cd ai-toolkit # 如果您还没有在 ai-toolkit 文件夹中
huggingface-cli login # 提供一个 `write` 令牌以在最后发布您的 LoRA
python flux_train_ui.py
```

您将实例化一个 UI，让您上传图像、为其添加标题、训练和发布您的 LoRA
![image](assets/lora_ease_ui.png)


## 在 RunPod 中训练
如果您想使用 Runpod，但尚未注册，请考虑使用[我的 Runpod 推荐链接](https://runpod.io?ref=h0y9jyr2)来帮助支持这个项目。

我在这里维护一个官方的 Runpod Pod 模板，可以在[这里](https://console.runpod.io/deploy?template=0fqzfjy6f3&ref=h0y9jyr2)访问。

我还创建了一个简短的视频，展示如何使用 Runpod 开始使用 AI Toolkit，[在这里](https://youtu.be/HBNeS-F6Zz8)。

## 在 Modal 中训练

### 1. 设置
#### ai-toolkit:
```bash
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
git submodule update --init --recursive
python -m venv venv
source venv/bin/activate
pip install torch
pip install -r requirements.txt
pip install --upgrade accelerate transformers diffusers huggingface_hub # 可选，如果遇到问题请运行
```

#### Modal:
- 运行 `pip install modal` 安装 modal Python 包。
- 运行 `modal setup` 进行身份验证（如果不起作用，请尝试 `python -m modal setup`）。

#### Hugging Face:
- 从[这里](https://huggingface.co/settings/tokens)获取 READ 令牌，并从[这里](https://huggingface.co/black-forest-labs/FLUX.1-dev)请求访问 Flux.1-dev 模型。
- 运行 `huggingface-cli login` 并粘贴您的令牌。

### 2. 上传您的数据集
- 将包含 .jpg、.jpeg 或 .png 图像和 .txt 文件的数据集文件夹拖放到 `ai-toolkit` 中。

### 3. 配置
- 将位于 `config/examples/modal` 的示例配置文件复制到 `config` 文件夹并将其重命名为 `whatever_you_want.yml`。
- 编辑配置，遵循文件中的注释，**<ins>注意并遵循示例 `/root/ai-toolkit` 路径</ins>**。


### 4. 编辑 run_modal.py
- 在 `code_mount = modal.Mount.from_local_dir` 设置您的整个本地 `ai-toolkit` 路径，如：
  
   ```python
   code_mount = modal.Mount.from_local_dir("/Users/username/ai-toolkit", remote_path="/root/ai-toolkit")
   ```
- 在 `@app.function` 中选择 `GPU` 和 `Timeout` _（默认为 A100 40GB 和 2 小时超时）_。

### 5. 训练
- 在终端中运行配置文件：`modal run run_modal.py --config-file-list-str=/root/ai-toolkit/config/whatever_you_want.yml`。
- 您可以在本地终端或 [modal.com](https://modal.com/) 上监控您的训练。
- 模型、样本和优化器将存储在 `Storage > flux-lora-models` 中。

### 6. 保存模型
- 通过运行 `modal volume ls flux-lora-models` 检查卷的内容。
- 通过运行 `modal volume get flux-lora-models your-model-name` 下载内容。
- 示例：`modal volume get flux-lora-models my_first_flux_lora_v1`。

### Modal 截图

<img width="1728" alt="Modal Training Screenshot" src="https://github.com/user-attachments/assets/7497eb38-0090-49d6-8ad9-9c8ea7b5388b">

---

## 数据集准备

数据集通常需要是包含图像和相关文本文件的文件夹。目前，唯一支持的格式是 jpg、jpeg 和 png。Webp 目前存在问题。文本文件应与图像同名，但扩展名为 `.txt`。例如 `image2.jpg` 和 `image2.txt`。文本文件应仅包含标题。
您可以在标题文件中添加单词 `[trigger]`，如果您在配置中有 `trigger_word`，它将自动替换。

图像永远不会被放大，但会被缩小并放入桶中进行批处理。**您不需要裁剪/调整图像大小**。
加载器将自动调整它们的大小，并可以处理不同的纵横比。


## 训练特定层

要使用 LoRA 训练特定层，您可以使用 `only_if_contains` 网络参数。例如，如果您只想训练 The Last Ben 使用的 2 层，[在此帖子中提到](https://x.com/__TheBen/status/1829554120270987740)，您可以像这样调整您的网络参数：

```yaml
      network:
        type: "lora"
        linear: 128
        linear_alpha: 128
        network_kwargs:
          only_if_contains:
            - "transformer.single_transformer_blocks.7.proj_out"
            - "transformer.single_transformer_blocks.20.proj_out"
```

层的命名约定采用 diffusers 格式，因此检查模型的状态字典将显示您想要训练的层名称的后缀。您还可以使用此方法仅训练特定的权重组。
例如，要仅训练 FLUX.1 的 `single_transformer`，您可以使用以下内容：

```yaml
      network:
        type: "lora"
        linear: 128
        linear_alpha: 128
        network_kwargs:
          only_if_contains:
            - "transformer.single_transformer_blocks."
```

您还可以使用 `ignore_if_contains` 网络参数按名称排除层。因此，要排除所有单个 transformer 块，

```yaml
      network:
        type: "lora"
        linear: 128
        linear_alpha: 128
        network_kwargs:
          ignore_if_contains:
            - "transformer.single_transformer_blocks."
```

`ignore_if_contains` 优先于 `only_if_contains`。因此，如果一个权重被两者覆盖，它将被忽略。

## LoKr 训练

要了解有关 LoKr 的更多信息，请阅读 [KohakuBlueleaf/LyCORIS](https://github.com/KohakuBlueleaf/LyCORIS/blob/main/docs/Guidelines.md)。要训练 LoKr 模型，您可以像这样调整配置文件中的网络类型：

```yaml
      network:
        type: "lokr"
        lokr_full_rank: true
        lokr_factor: 8
```

其他一切都应该以相同的方式工作，包括层定位。


## Docker 使用

### 使用 docker-compose（推荐）

项目提供了完整的 Docker 支持。最简单的方式是使用 docker-compose：

```bash
# 1. 克隆项目
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit

# 2. 设置认证密码（可选但推荐）
export AI_TOOLKIT_AUTH=your_password

# 3. 启动容器
docker-compose up -d

# 4. 访问 UI
# 浏览器打开 http://localhost:8675
```

**docker-compose.yml 配置说明：**
- **端口映射**：`8675:8675` - UI 访问端口
- **卷挂载**：
  - `~/.cache/huggingface/hub` - HuggingFace 模型缓存
  - `./aitk_db.db` - 数据库文件
  - `./datasets` - 训练数据集
  - `./output` - 输出结果
  - `./config` - 配置文件
- **GPU 支持**：自动使用所有 NVIDIA GPU
- **环境变量**：
  - `AI_TOOLKIT_AUTH` - UI 访问密码（默认：password）

### 手动构建和运行

```bash
# 1. 构建镜像
docker build -f docker/Dockerfile -t ai-toolkit:latest .

# 2. 运行容器
docker run -d \
  --gpus all \
  -p 8675:8675 \
  -v ~/.cache/huggingface/hub:/root/.cache/huggingface/hub \
  -v $(pwd)/output:/app/ai-toolkit/output \
  -v $(pwd)/config:/app/ai-toolkit/config \
  -v $(pwd)/datasets:/app/ai-toolkit/datasets \
  -e AI_TOOLKIT_AUTH=your_password \
  ai-toolkit:latest
```

### 重要说明

1. **GPU 要求**：需要 NVIDIA GPU（至少 24GB 显存用于 FLUX.1 训练）
2. **HuggingFace Token**：如果训练 FLUX.1-dev，需要：
   - 在 HF 上接受模型许可：https://huggingface.co/black-forest-labs/FLUX.1-dev
   - 创建 `.env` 文件并添加：`HF_TOKEN=your_token_here`
3. **访问 UI**：启动后访问 `http://localhost:8675`
4. **安全性**：如果在公网运行，务必设置 `AI_TOOLKIT_AUTH` 密码

### 查看日志

```bash
# docker-compose 方式
docker-compose logs -f

# 手动运行方式
docker logs -f <container_id>
```


## 更新

这里只列出较大的更新。通常会有较小的每日更新被省略。

### 2025年7月17日
- 使在 UI 中轻松添加控制图像到样本

### 2025年7月11日
- 为视频模型在 UI 中添加了更好的视频配置设置
- 在 UI 中添加了 Wan I2V 训练

### 2025年6月29日
- 修复了 Kontext 强制大小的问题

### 2025年6月26日
- 添加了对 FLUX.1 Kontext 训练的支持
- 添加了对指令数据集训练的支持

### 2025年6月25日
- 添加了对 OmniGen2 训练的支持

### 2025年6月17日
- 批处理准备的性能优化
- 通过弹出窗口为简单 UI 中的项目添加了一些文档，解释设置的作用。仍在进行中

### 2025年6月16日
- 在 UI 中查看数据集时隐藏控制图像
- 平均流损失的 WIP

### 2025年6月12日
- 修复了导致数据加载器中标题为空的问题

### 2025年6月10日
- 决定在 readme 中跟踪更新
- 在 UI 中添加了对 SDXL 的支持
- 在 UI 中添加了对 SD 1.5 的支持
- 修复了 UI Wan 2.1 14b 名称错误
- 在 UI 中为支持它的模型添加了对卷积训练的支持

---

## 许可证

本项目采用 Apache 2.0 许可证。详情请参阅 [LICENSE](LICENSE) 文件。

## 贡献

欢迎贡献！请随时提交 Pull Request。

## 致谢

感谢所有赞助商和贡献者使这个项目成为可能！

