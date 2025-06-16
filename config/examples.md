# Window Configuration Examples

## 위치 설정 예시

### 중앙 하단 (기본값)

```json
{
  "window": {
    "position": {
      "x": "center-bottom",
      "y": "bottom",
      "offsetX": 0,
      "offsetY": -50
    }
  }
}
```

### 왼쪽 하단

```json
{
  "window": {
    "position": {
      "x": "left",
      "y": "bottom",
      "offsetX": 20,
      "offsetY": -20
    }
  }
}
```

### 오른쪽 하단

```json
{
  "window": {
    "position": {
      "x": "right",
      "y": "bottom",
      "offsetX": -20,
      "offsetY": -20
    }
  }
}
```

### 정확한 좌표 지정

```json
{
  "window": {
    "position": {
      "x": 100,
      "y": 200,
      "offsetX": 0,
      "offsetY": 0
    }
  }
}
```

### 중앙 위치

```json
{
  "window": {
    "position": {
      "x": "center",
      "y": "center",
      "offsetX": 0,
      "offsetY": 0
    }
  }
}
```

## 크기 설정 예시

### 작은 위젯

```json
{
  "window": {
    "width": 300,
    "height": 400,
    "minWidth": 250,
    "minHeight": 300
  }
}
```

### 큰 위젯

```json
{
  "window": {
    "width": 600,
    "height": 800,
    "minWidth": 400,
    "minHeight": 500
  }
}
```

## UI 설정 예시

### 반투명 다크 테마

```json
{
  "ui": {
    "theme": "dark",
    "transparency": 0.9,
    "borderRadius": 16,
    "showScrollbar": false,
    "showTitleBar": false,
    "roundedCorners": true
  }
}
```

### 타이틀바 표시된 라이트 테마

```json
{
  "ui": {
    "theme": "light",
    "transparency": 1.0,
    "borderRadius": 8,
    "showScrollbar": true,
    "showTitleBar": true,
    "roundedCorners": false
  }
}
```

## 동작 설정 예시

### 트레이로 숨김 + 작업표시줄 숨김

```json
{
  "behavior": {
    "hideToTray": true,
    "startMinimized": false,
    "autoStart": true,
    "hideFromTaskbar": true
  }
}
```

### 항상 보이기

```json
{
  "behavior": {
    "hideToTray": false,
    "startMinimized": false,
    "autoStart": false,
    "hideFromTaskbar": false
  }
}
```
