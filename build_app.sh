#!/bin/bash

# 색상 정의 (출력 가독성 향상)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "Android 앱 비디오 교체 및 빌드 스크립트"
echo "======================================"
echo ""

# 1. new_video.mp4 파일 존재 확인
if [ ! -f "new_video.mp4" ]; then
    echo -e "${RED}[오류]${NC} 프로젝트 루트에 new_video.mp4 파일이 없습니다."
    exit 1
fi
echo -e "${GREEN}✓${NC} new_video.mp4 파일 확인 완료"

# 2. 앱 이름 입력받기
echo ""
read -p "런처에 표시할 앱 이름을 입력하세요: " APP_NAME

if [ -z "$APP_NAME" ]; then
    echo -e "${RED}[오류]${NC} 앱 이름은 필수입니다."
    exit 1
fi
echo -e "${GREEN}✓${NC} 앱 이름: $APP_NAME"

# 3. raw 디렉토리 확인 및 생성
RAW_DIR="app/src/main/res/raw"
if [ ! -d "$RAW_DIR" ]; then
    echo -e "${YELLOW}[알림]${NC} raw 디렉토리가 없습니다. 생성합니다..."
    mkdir -p "$RAW_DIR"
fi

# 4. 비디오 파일 교체
echo ""
echo "비디오 파일을 교체합니다..."
cp new_video.mp4 "$RAW_DIR/video.mp4"
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} 비디오 파일 교체 완료"
else
    echo -e "${RED}[오류]${NC} 비디오 파일 교체 실패"
    exit 1
fi

# 5. strings.xml 파일 경로
STRINGS_XML="app/src/main/res/values/strings.xml"

if [ ! -f "$STRINGS_XML" ]; then
    echo -e "${RED}[오류]${NC} strings.xml 파일을 찾을 수 없습니다: $STRINGS_XML"
    exit 1
fi

# 6. app_name 수정
echo ""
echo "앱 이름을 변경합니다..."

# macOS와 Linux에서 sed 명령어가 다르므로 분기 처리
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">$APP_NAME</string>|g" "$STRINGS_XML"
else
    # Linux
    sed -i "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">$APP_NAME</string>|g" "$STRINGS_XML"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} 앱 이름 변경 완료"
else
    echo -e "${RED}[오류]${NC} 앱 이름 변경 실패"
    exit 1
fi

# 7. gradlew 실행 권한 확인
if [ ! -x "./gradlew" ]; then
    echo -e "${YELLOW}[알림]${NC} gradlew 실행 권한을 부여합니다..."
    chmod +x ./gradlew
fi

# 8. Debug APK 빌드
echo ""
echo "======================================"
echo "Debug APK 빌드를 시작합니다..."
echo "======================================"
echo ""

./gradlew assembleDebug

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}======================================"
    echo "✓ 빌드 완료!"
    echo "======================================${NC}"
    echo ""
    echo "생성된 APK 위치:"
    echo "  app/build/outputs/apk/debug/app-debug.apk"
    echo ""
else
    echo ""
    echo -e "${RED}[오류]${NC} 빌드 실패"
    exit 1
fi