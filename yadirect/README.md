# Яндекс.Директ Сервис

Автоматизированный сервис для создания и управления рекламными кампаниями в Яндекс.Директе с использованием OpenAI для генерации объявлений.

## 🚀 Возможности

- **OAuth авторизация** в Яндекс.Директ
- **Автоматическое создание кампаний** на основе данных страниц
- **Генерация объявлений** с помощью OpenAI GPT-4
- **Создание групп объявлений** и ключевых слов
- **Обработка файлов** в форматах YAML, MD, TXT
- **Веб-интерфейс** для удобного управления
- **API для интеграции** с другими системами

## 📋 Требования

- Node.js 16+
- Аккаунт в Яндекс.Директ
- API ключ OpenAI
- OAuth приложение в Яндексе

## 🛠 Установка

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd yadirecrt
```

2. Установите зависимости:
```bash
npm install
```

3. Создайте файл `.env` на основе `.env.example`:
```bash
cp .env.example .env
```

4. Заполните переменные окружения в `.env`:
```env
YANDEX_CLIENT_ID=
YANDEX_CLIENT_SECRET=
YANDEX_REDIRECT_URI=https://habab.ru/redirect
OPENAI_API_KEY=your_openai_api_key_here
PORT=3000
```

5. Создайте необходимые директории:
```bash
mkdir logs uploads
```

## 🚀 Запуск

### Режим разработки
```bash
npm run dev
```

### Продакшн
```bash
npm start
```

Сервис будет доступен по адресу: `http://localhost:3000`

## 📁 Формат входных файлов

Сервис принимает файлы в следующем формате:

```yaml
---
url: https://habab.ru/brachnogo-dogovora
title: Проверка договора брачного договора онлайн нейросетью
meta_description: 'Бесплатная онлайн проверка брачного договора с нейросетью'
meta_keywords:
- проверка брачного договора
- анализ условий брачного договора
- юридическая проверка брачного договора
related_keywords:
- юридическая экспертиза брачного договора
- консультация по брачному договору
main_keyword: брачного договора
---

Основной контент страницы...
```

### Обязательные поля:
- `url` - URL целевой страницы
- `title` - Заголовок страницы

### Опциональные поля:
- `meta_description` - Описание страницы
- `meta_keywords` - Массив ключевых слов
- `related_keywords` - Массив связанных ключевых слов
- `main_keyword` - Основное ключевое слово

## 🔐 Авторизация

### Получение токенов

Проект содержит несколько скриптов для работы с токенами Яндекс.Директ:

#### 1. `get_yandex_token.js` - Получение основного токена
Скрипт для получения OAuth токена для работы с продакшн API Яндекс.Директ:
```bash
node get_yandex_token.js
```

**Важно**: Для работы с продакшн API требуется одобренная заявка на доступ.

#### 2. `get_sandbox_oauth_token.js` - Получение токена для песочницы
Скрипт для получения OAuth токена для работы с песочницей Яндекс.Директ:
```bash
node get_sandbox_oauth_token.js
```

#### 3. `test_sandbox.js` - Тестирование песочницы
Простой тест подключения к песочнице:
```bash
node test_sandbox.js
```

### Переменные окружения (.env)

```env
# Данные приложения Яндекс
YANDEX_CLIENT_ID=your_client_id
YANDEX_CLIENT_SECRET=your_client_secret
YANDEX_REDIRECT_URI=your_redirect_uri

# Токены
YANDEX_DIRECT_TOKEN=your_production_token          # Для продакшн API
YANDEX_SANDBOX_TOKEN=your_master_token             # Мастер-токен песочницы
YANDEX_SANDBOX_OAUTH_TOKEN=your_sandbox_oauth_token # OAuth токен для песочницы

# OpenAI
OPENAI_API_KEY=your_openai_api_key

# Сервер
PORT=3000
```

### Работа с песочницей

Яндекс.Директ предоставляет песочницу для тестирования API без влияния на реальные кампании:

- **URL песочницы**: `https://api-sandbox.direct.yandex.com`
- **URL продакшн**: `https://api.direct.yandex.com`

**Типы токенов для песочницы**:
1. **Мастер-токен** (`YANDEX_SANDBOX_TOKEN`) - для управления песочницей (создание/очистка тестовых данных)
2. **OAuth токен** (`YANDEX_SANDBOX_OAUTH_TOKEN`) - для работы с API песочницы

**Получение доступа к песочнице**:
1. Зайдите в Яндекс.Директ → Настройки API → Песочница
2. Получите мастер-токен
3. Создайте тестовые кампании
4. Получите OAuth токен для API через `get_sandbox_oauth_token.js`

## 📁 Структура проекта

```
yadirect/
├── get_yandex_token.js           # Получение основного OAuth токена
├── get_sandbox_oauth_token.js    # Получение OAuth токена для песочницы  
├── test_sandbox.js               # Тестирование подключения к песочнице
├── docs/                         # Документация Яндекс.Директ API
│   └── yandex_direct/           # Скачанная документация API
├── src/                         # Основной код приложения
├── tests/                       # Тесты
└── .env                         # Переменные окружения
```

## 📚 API Документация

### Правильный формат запросов к Яндекс.Директ

Все запросы к API должны соответствовать следующему формату:

**URL**: `https://api.direct.yandex.com/json/v5/{service}`

**Заголовки**:
```
Authorization: Bearer YOUR_ACCESS_TOKEN
Content-Type: application/json
Accept-Language: ru
```

**Тело запроса**:
```json
{
  "method": "get|add|update|delete",
  "params": {
    // параметры запроса
  }
}
```

### Примеры запросов

#### Получение кампаний
```bash
curl -X POST https://api.direct.yandex.com/json/v5/campaigns \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "method": "get",
    "params": {
      "SelectionCriteria": {},
      "FieldNames": ["Id", "Name", "Status"]
    }
  }'
```

#### Создание кампании
```bash
curl -X POST https://api.direct.yandex.com/json/v5/campaigns \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "method": "add",
    "params": {
      "Campaigns": [{
        "Name": "Тестовая кампания",
        "Type": "TEXT_CAMPAIGN",
        "Status": "DRAFT",
        "TextCampaign": {
          "BiddingStrategy": {
            "Search": {
              "BiddingStrategyType": "HIGHEST_POSITION"
            },
            "Network": {
              "BiddingStrategyType": "SERVING_OFF"
            }
          }
        }
      }]
    }
  }'
```

### Авторизация

#### `GET /auth/yandex/url`
Получение URL для авторизации в Яндексе

#### `GET /auth/yandex/callback`
Обработка колбэка от Яндекса (получение токена)

#### `POST /auth/yandex/validate`
Проверка валидности токена
```json
{
  "access_token": "your_token_here"
}
```

### Кампании

#### `GET /api/campaigns`
Получение списка кампаний (требует авторизации)

#### `POST /api/campaigns`
Создание новой кампании
```json
{
  "pageData": {
    "url": "https://example.com",
    "title": "Page Title",
    "meta_description": "Page description",
    "meta_keywords": ["keyword1", "keyword2"],
    "main_keyword": "main keyword"
  },
  "generateAds": true
}
```

#### `POST /api/campaigns/generate-ads`
Генерация объявлений на основе данных страницы

#### `POST /api/campaigns/generate-keywords`
Генерация ключевых слов

#### `GET /api/campaigns/:id/stats`
Получение статистики кампании

### Файлы

#### `POST /api/process-file`
Обработка загруженного файла
- Поддерживаемые форматы: `.yaml`, `.yml`, `.txt`, `.md`
- Multipart/form-data с полем `file`
- Требует `accessToken` в теле запроса

## 🏗 Архитектура

```
src/
├── index.js                 # Основной файл приложения
├── routes/
│   ├── auth.js             # Роуты авторизации
│   └── campaigns.js        # Роуты управления кампаниями
├── services/
│   ├── yandexDirectService.js  # Сервис работы с Яндекс.Директ API
│   ├── openaiService.js        # Сервис работы с OpenAI
│   └── fileProcessor.js        # Обработка файлов
└── utils/
    └── logger.js               # Логирование
```

## 🌐 Веб-интерфейс

Сервис включает современный веб-интерфейс:
- Авторизация в Яндекс.Директ
- Загрузка и обработка файлов
- Просмотр кампаний
- Генерация объявлений
- Скачивание примеров файлов

Доступен по адресу: `http://localhost:3000`

## 🔧 Конфигурация

### Переменные окружения

| Переменная | Описание | Обязательная |
|------------|----------|--------------|
| `YANDEX_CLIENT_ID` | ID OAuth приложения | Да |
| `YANDEX_CLIENT_SECRET` | Секрет OAuth приложения | Да |
| `YANDEX_REDIRECT_URI` | URI для редиректа | Да |
| `OPENAI_API_KEY` | API ключ OpenAI | Да |
| `PORT` | Порт сервера | Нет (3000) |
| `NODE_ENV` | Режим работы | Нет (development) |
| `LOG_LEVEL` | Уровень логирования | Нет (info) |

### Логирование

Логи сохраняются в директории `logs/`:
- `error.log` - только ошибки
- `combined.log` - все логи

В режиме разработки логи также выводятся в консоль.

## 🔧 Тестирование

Для проверки правильности работы с API используйте тестовые скрипты:

### Полный тест API
```bash
node test_api.js YOUR_ACCESS_TOKEN
```

### Тест структуры запросов
```bash
node test_structure.js YOUR_ACCESS_TOKEN
```

### Получение токена для тестирования
1. Запустите сервер: `npm start`
2. Откройте: `http://localhost:3000/auth/yandex/url`
3. Перейдите по ссылке авторизации
4. Скопируйте полученный токен

## 🧪 Тестирование

Проект содержит комплексный набор тестов для обеспечения качества и надежности кода.

### Структура тестов

```
tests/
├── unit/                    # Юнит-тесты отдельных модулей
│   ├── fileProcessor.test.js
│   ├── openaiService.test.js
│   ├── yandexDirectService.test.js
│   ├── logger.test.js
│   ├── auth.test.js
│   └── campaigns.test.js
├── integration/             # Интеграционные тесты API
│   ├── api.test.js
│   └── advanced.test.js
├── e2e/                     # End-to-end тесты сценариев
│   └── scenarios.test.js
├── performance/             # Тесты производительности
│   └── load.test.js
├── security/                # Тесты безопасности
│   └── security.test.js
├── helpers/                 # Утилиты для тестов
│   └── testUtils.js
├── config/                  # Конфигурация тестов
│   └── testConfig.js
├── fixtures/                # Тестовые данные
│   └── testData.js
└── setup.js                # Настройка тестовой среды
```

### Типы тестов

#### 🔧 Юнит-тесты
Тестируют отдельные компоненты изолированно:

```bash
# Запуск всех юнит-тестов
npm run test:unit

# Запуск конкретного теста
npm run test:unit -- fileProcessor.test.js
```

#### 🔗 Интеграционные тесты
Проверяют взаимодействие между компонентами:

```bash
# Запуск интеграционных тестов
npm run test:integration

# С детальным выводом
npm run test:integration -- --verbose
```

#### 🎭 E2E тесты
Тестируют полные пользовательские сценарии:

```bash
# Запуск E2E тестов
npm run test:e2e

# Только сценарии авторизации
npm run test:e2e -- --testNamePattern="Authorization"
```

#### ⚡ Тесты производительности
Проверяют скорость отклика и нагрузочную способность:

```bash
# Запуск тестов производительности
npm run test:performance

# Тесты с увеличенным timeout
npm run test:performance -- --testTimeout=120000
```

#### 🔒 Тесты безопасности
Проверяют защиту от атак и уязвимостей:

```bash
# Запуск тестов безопасности
npm run test:security
```

### Скрипты тестирования

```bash
# Все тесты
npm test

# Тесты с покрытием кода
npm run test:coverage

# Тесты в режиме наблюдения
npm run test:watch

# CI/CD режим
npm run test:ci

# Ручные тесты API
npm run test:api YOUR_ACCESS_TOKEN
npm run test:structure
```

### Покрытие кода

Проект настроен на достижение следующих показателей покрытия:
- **Функции**: 70%
- **Строки**: 70%
- **Ветки**: 70%
- **Выражения**: 70%

```bash
# Генерация отчета о покрытии
npm run test:coverage

# Отчет сохраняется в coverage/lcov-report/index.html
```

### Настройка тестовой среды

#### Переменные окружения для тестов

Создайте файл `.env.test`:

```env
NODE_ENV=test
LOG_LEVEL=silent

# Тестовые токены (не реальные)
YANDEX_CLIENT_ID=test_client_id
YANDEX_CLIENT_SECRET=test_client_secret
YANDEX_REDIRECT_URI=http://localhost:3000/auth/yandex/callback
OPENAI_API_KEY=test_openai_key

# Настройки тестовой БД/API
TEST_API_URL=http://localhost:3001
```

#### Моки и фикстуры

Проект использует Jest моки для изоляции внешних зависимостей:

```javascript
// Пример использования мока в тесте
const YandexDirectService = require('../src/services/yandexDirectService');
jest.mock('../src/services/yandexDirectService');

const mockService = YandexDirectService.mockImplementation(() => ({
  getCampaigns: jest.fn().mockResolvedValue({ Campaigns: [] })
}));
```

### Отладка тестов

#### Запуск отдельного теста
```bash
npm test -- --testNamePattern="должен создать кампанию"
```

#### Запуск тестов с отладкой
```bash
npm test -- --verbose --no-coverage
```

#### Пропуск медленных тестов
```bash
npm test -- --testPathIgnorePatterns=performance
```

### Непрерывная интеграция

Для CI/CD используйте команду:
```bash
npm run test:ci
```

Она выполняет:
- Все типы тестов
- Проверку покрытия кода
- Генерацию отчетов
- Отключение watch режима

### Примеры тестов

#### Юнит-тест сервиса
```javascript
describe('YandexDirectService', () => {
  test('должен получить список кампаний', async () => {
    const service = new YandexDirectService('test_token');
    const campaigns = await service.getCampaigns();
    
    expect(campaigns).toHaveProperty('Campaigns');
    expect(Array.isArray(campaigns.Campaigns)).toBe(true);
  });
});
```

#### Интеграционный тест API
```javascript
describe('API Integration', () => {
  test('POST /api/campaigns должен создать кампанию', async () => {
    const response = await request(app)
      .post('/api/campaigns')
      .set('Authorization', 'Bearer valid_token')
      .send({ pageData: testPageData })
      .expect(200);

    expect(response.body).toHaveProperty('success', true);
    expect(response.body).toHaveProperty('campaignId');
  });
});
```

#### Тест производительности
```javascript
test('должен обрабатывать 50 запросов за 5 секунд', async () => {
  const requests = Array(50).fill().map(() => 
    request(app).get('/api/status')
  );

  const startTime = Date.now();
  await Promise.all(requests);
  const duration = Date.now() - startTime;

  expect(duration).toBeLessThan(5000);
});
```

### Best Practices

1. **Изоляция тестов**: Каждый тест должен быть независимым
2. **Моки внешних сервисов**: Используйте Jest моки для API
3. **Фикстуры**: Храните тестовые данные в отдельных файлах
4. **Описательные названия**: Тесты должны читаться как документация
5. **Проверка edge cases**: Тестируйте граничные случаи и ошибки

### Устранение неполадок

#### Тесты падают локально
1. Проверьте переменные окружения в `.env.test`
2. Убедитесь, что порты свободны
3. Очистите кэш Jest: `npx jest --clearCache`

#### Низкое покрытие
1. Добавьте тесты для непокрытых функций
2. Проверьте исключения в `jest.config.js`
3. Удалите мертвый код

#### Медленные тесты
1. Используйте моки вместо реальных API вызовов
2. Оптимизируйте тестовые данные
3. Запускайте тесты параллельно

## 📚 Документация

Проект содержит полную документацию Яндекс.Директ API в папке `docs/yandex_direct/`:
- Методы API
- Объекты и структуры данных
- Примеры запросов
- Описание ошибок

Официальная документация: https://yandex.ru/dev/direct/
