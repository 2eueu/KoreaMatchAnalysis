# KoreaMatchAnalysis ⚽🇰🇷  
**Analyze South Korea's football match data with insights into match results, win rates, and predictive modeling using KNN and SVM algorithms.**

---

## 🏆 **프로젝트 개요**  
대한민국 축구 경기 데이터를 분석하여 경기 결과, 승률, KNN 및 SVM 알고리즘을 활용한 예측 모델링을 제공합니다.

---

## **🛠️ 사용 기술 스택**  

### **언어**
[![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=R&logoColor=white)](https://www.r-project.org/)

### **라이브러리**
- **dplyr**: 데이터 조작 및 요약
- **caret**: 모델 학습 및 데이터 분할
- **e1071**: SVM 모델 구축
- **ggplot2**: 데이터 시각화

---

## 🔍 **주요 기능**

1. **대한민국 축구 경기 필터링**
   - 대한민국이 홈팀 또는 원정팀으로 참가한 경기를 필터링합니다.
   - `home_team`과 `away_team` 데이터를 기준으로 상대국과의 경기 결과를 계산합니다.

2. **상대국별 승률 분석**
   - 대한민국과 각 상대국 간의 승, 무, 패를 요약하여 승률 계산.
   - 주요 상대국(독일, 브라질, 일본 등)에 대한 승률을 별도로 시각화.

3. **KNN과 SVM 모델 학습 및 예측**
   - **KNN**과 **SVM** 알고리즘을 사용해 경기 결과(승, 무, 패)를 예측합니다.
   - 모델의 성능을 혼동 행렬(Confusion Matrix) 및 정확도로 평가.

4. **모델 성능 비교**
   - KNN과 SVM의 정확도를 비교하여 최적 모델을 선정합니다.
   - 시각화를 통해 두 모델의 성능을 효과적으로 전달.

---

## 📊 **데이터 시각화**

1. **대한민국과 주요 상대국의 승률**
   - 주요 상대국(독일, 브라질 등)과의 경기 승률을 막대그래프로 시각화.
   - 승률이 높은 순서대로 정렬.

2. **혼동 행렬**
   - KNN과 SVM 모델의 혼동 행렬을 각각 타일 형식의 그래프로 시각화.
   - 모델의 예측 결과를 시각적으로 비교.

3. **모델 정확도 비교**
   - KNN과 SVM 모델의 정확도를 비교한 막대그래프.

---



