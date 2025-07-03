# 🚢 Админка портового терминала

Система для анализа данных портового терминала с использованием ИИ для генерации SQL запросов. Приложение построено на Flask.

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
# Создание виртуального окружения
python3 -m venv venv
source venv/bin/activate

# Установка Python пакетов
pip install -r requirements.txt
```

*Примечание: Для установки `pyodbc` в Linux может потребоваться установить системные зависимости, например `unixodbc-dev`.*
```bash
# Пример для Debian/Ubuntu
sudo apt-get install unixodbc-dev
```

### 2. Установка ODBC-драйвера для SQL Server (Обязательно)

Для подключения к MS SQL Server из Linux-окружения (например, из Codespaces) необходимо установить официальный ODBC-драйвер от Microsoft.

**Для систем на базе Debian/Ubuntu:**
Выполните следующие команды в терминале, чтобы зарегистрировать ключ Microsoft, добавить репозиторий и установить драйвер:
```bash
sudo apt-get update
sudo apt-get install -y curl apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/debian/11/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
```

### 3. Настройка базы данных и токена HuggingFace

Убедитесь, что файл `.env` содержит правильные данные для подключения:

```env
DB_HOST=

```

### 4. Получение токена HuggingFace

1. Зарегистрируйтесь на [HuggingFace](https://huggingface.co/) и создайте аккаунт.
2. Перейдите в настройки профиля -> [Access Tokens](https://huggingface.co/settings/tokens).
3. Создайте новый токен с правами "Read".
4. Скопируйте токен и вставьте его в файл `.env`.

### 5. Запуск админки

```bash
# Запуск Flask-приложения
pip install -r requirements.txt
```

Админка будет доступна по адресу: http://localhost:8080

### Запуск в Codespaces

Приложение автоматически определит, что запущено в Codespaces, и настроит URL для API.

**1. Запустите Flask бэкенд в первом терминале:**
```bash
python vagon/app.py
```

**2. Запустите Streamlit фронтенд во втором терминале:**
```bash
streamlit run vagon/vagon_dashboard.py
```
Codespaces автоматически перенаправит порты, и вы сможете открыть оба приложения в браузере.

## 📊 Возможности

### Основные функции:
- **Генерация SQL запросов** - ИИ автоматически создает SQL запросы на основе естественного языка.
- **Выполнение запросов** - Прямое выполнение SQL запросов к базе данных.
- **Просмотр статистики** - Отображение основной статистики по таблицам базы данных.

### Примеры запросов для LLM:

- *Покажи 5 самых тяжелых грузов, принятых в этом месяце.*
- *Как менялась выгрузка вагонов в течение последнего года, помесячно?*
- *Сколько вагонов было выгружено вчера по каждому типу груза?*

## 🗄️ Структура базы данных

### Основные таблицы:
- **VagonImport**: Данные о выгрузке вагонов.
- **ShipsImport**: Данные о судах.
- **EnterpriseWagons**: Вагоны на предприятии.
- **StorageFullness**: Заполненность складов.
- **ShipmentsToThePort**: Отгрузки в порт.

## 🔧 Файлы проекта

- `app.py` - Основной файл Flask-приложения (бэкенд).
- `templates/index.html` - Файл с HTML-разметкой и JS-логикой (фронтенд).
- `requirements.txt` - Python зависимости.
- `.env` - Файл с настройками подключения и токенами.
- `db_shema.sql` - Схема базы данных.
- `admin_dashboard.py` - (Устарело) Старая версия на Streamlit.

## 🤖 Использование ИИ

Система использует модель **Qwen/Qwen2.5-Coder-0.5B-Instruct** через HuggingFace API для генерации SQL запросов из естественного языка.

### Настройка HuggingFace API

Для работы с HuggingFace API используется правильный endpoint:

```python
import os
import requests

API_URL = "https://router.huggingface.co/featherless-ai/v1/chat/completions"
headers = {
    "Authorization": f"Bearer {os.environ['HF_TOKEN']}",
}

def query(payload):
    response = requests.post(API_URL, headers=headers, json=payload)
    return response.json()

response = query({
    "messages": [
        {
            "role": "user",
            "content": "What is the capital of France?"
        }
    ],
    "model": "Qwen/Qwen2.5-Coder-0.5B-Instruct"
})

print(response["choices"][0]["message"])
```

### Пример работы

1.  **Запрос на естественном языке**: "Покажи 10 последних операций по погрузке угля"
2.  **Сгенерированный SQL**: `SELECT TOP 10 * FROM [dbo].[VagonImport] WHERE [Род груза] = 'Уголь' AND [Операция] = 'Погрузка' ORDER BY [Дата и время погрузки] DESC`
3.  **Результат**: Таблица с данными.
