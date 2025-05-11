# Use uma imagem base oficial do Python
FROM python:3.10-slim

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o arquivo de dependências (requirements.txt ou poetry.lock) para o diretório de trabalho
COPY pyproject.toml poetry.lock /app/

# Instale o Poetry e as dependências
RUN pip install poetry && poetry install --no-root

# Copie o restante dos arquivos da aplicação para dentro do container
COPY . /app

# Defina as variáveis de ambiente necessárias (se houver)
ENV PYTHONUNBUFFERED=1

# Exponha a porta que o aplicativo irá utilizar
EXPOSE 8080

# Defina o comando para rodar a aplicação
CMD ["poetry", "run", "python", "src/app.py"]
