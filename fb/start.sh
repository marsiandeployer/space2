#!/bin/bash

# Скрипт для быстрого запуска WhatsApp Bulk Sender

echo "=== WhatsApp Bulk Sender - Запуск ==="
echo ""

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 не найден. Установите Python 3.7+ для продолжения."
    exit 1
fi

echo "✅ Python найден: $(python3 --version)"

# Проверка зависимостей
if [ ! -f "requirements.txt" ]; then
    echo "❌ Файл requirements.txt не найден"
    exit 1
fi

echo "📦 Установка зависимостей..."
pip3 install -r requirements.txt

# Проверка файла .env
if [ ! -f ".env" ]; then
    echo "⚠️  Файл .env не найден"
    echo "📋 Создаю файл .env из примера..."
    cp .env.example .env
    echo "✏️  Отредактируйте файл .env и добавьте ваши токены и настройки"
    echo ""
    echo "Необходимые переменные:"
    echo "- ACCESS_TOKEN: Токен доступа WhatsApp Business API"
    echo "- WHATSAPP_BUSINESS_ACCOUNT_ID: ID вашего WABA"
    echo "- NUMBER: Номер телефона в формате +1234567890"
    echo "- PIN: 6-значный PIN для двухфакторной аутентификации"
    echo ""
    read -p "Нажмите Enter после настройки .env файла..."
fi

echo "🔧 Проверка конфигурации..."

# Проверка основных переменных
if [ ! -s ".env" ]; then
    echo "❌ Файл .env пуст. Заполните необходимые переменные."
    exit 1
fi

# Проверка активации номера
echo "📱 Проверка активации номера телефона..."
if [ -f "activate.py" ]; then
    echo "ℹ️  Если номер не активирован, запустите: python3 activate.py"
else
    echo "❌ Файл activate.py не найден"
fi

echo ""
echo "🚀 Запуск веб-интерфейса..."
echo "🌐 Откройте браузер и перейдите на: http://localhost:5000"
echo "⏹️  Для остановки нажмите Ctrl+C"
echo ""

# Запуск Flask приложения
python3 app.py
