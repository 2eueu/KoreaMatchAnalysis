# 패키지 로드 # 
library(dplyr)
library(caret)
library(e1071)
library(ggplot2)

### 데이터 불러오기 및 전처리 ###
# 데이터 불러오기 # 
df <- read.csv("results.csv")

# 대한민국 경기만 필터링 #
korea_matches <- df %>% 
  filter(home_team == "South Korea" | away_team == "South Korea")

# 승패 결과 생성 # 
korea_matches$result <- ifelse(
  korea_matches$home_team == "South Korea" & korea_matches$home_score > korea_matches$away_score, "Win", 
  ifelse(korea_matches$away_team == "South Korea" & korea_matches$away_score > korea_matches$home_score, "Win",
         ifelse(korea_matches$home_score == korea_matches$away_score, "Draw", "Loss")
  )
)
# 상대국 컬럼 추가 # 
korea_matches$opponent <- ifelse(korea_matches$home_team == "South Korea", korea_matches$away_team, korea_matches$home_team)

# 결과 확인 # 
head(korea_matches)


### 데이터 요약 및 시각화 ###
# 승, 무, 패 요약 # 
win_rates <- korea_matches %>% 
  group_by(opponent) %>% 
  summarise(
    Win = sum(result == "Win"), 
    Draw = sum(result == "Draw"), 
    Loss = sum(result == "Loss"), 
    Total = n(), 
    WinRate = Win / Total 
  ) %>%  
  arrange(desc(WinRate))

# 승률 데이터 확인 # 
print(win_rates)

# 승률 시각화 # 
ggplot(win_rates, aes(x = reorder(opponent, WinRate), y = WinRate)) +
  geom_col(fill = "skyblue") +
  geom_text(aes(label = round(WinRate, 2)), hjust = -0.2, size = 3) +
  coord_flip() +
  labs(title = "대한민국과 각국과의 승률", x = "상대국", y = "승률") +
  theme_light() +
  theme(axis.text.y = element_text(size = 10))

# 주요 국가 리스트
famous_countries <- c("Germany", "Brazil", "Argentina", "France", "Italy", "England", "Japan", "Spain", "Netherlands", "Portugal")

# 주요 국가만 필터링
filtered_win_rates <- win_rates %>%
  filter(opponent %in% famous_countries)

# 그래프 그리기
ggplot(filtered_win_rates, aes(x = reorder(opponent, WinRate), y = WinRate)) +
  geom_col(fill = "skyblue") +
  geom_text(aes(label = round(WinRate, 2)), hjust = -0.2, size = 4) +
  coord_flip() +
  labs(title = "Winning Rate of South Korea Against Famous Opponents", 
       x = "Opponent", 
       y = "Winning Rate") +
  theme_light() +
  theme(axis.text.y = element_text(size = 12))


### 데이터 준비 및 모델링 ###
# 대한민국 경기에 필요한 변수 선택 #
model_data <- korea_matches %>% 
  mutate(
    home = ifelse(home_team == "South Korea", 1, 0), 
    neutral = ifelse(neutral, 1, 0)
  ) %>% 
  select(home, home_score, away_score, neutral, result)

# 결과 변수를 팩터로 변환 #
model_data$result <- as.factor(model_data$result)

# 결측치 제거 #
model_data <- na.omit(model_data)

# 데이터 확인 # 
head(model_data)


### 데이터 나누기 (훈련 및 테스트 세트 ) ###
set.seed(123)
train_index <- createDataPartition(model_data$result, p = 0.8, list = FALSE)
train <- model_data[train_index, ]
test <- model_data[-train_index, ]


### KNN 모델 학습 및 예측 ###
# KNN 모델 학습 # 
knn_model <- train(result ~ ., data = train, method = "knn", tuneLength = 5)

# 예측 # 
knn_pred <-  predict(knn_model, test)

# 성능 평가 # 
confusionMatrix(knn_pred, test$result)

# KNN 모델의 혼동 행렬
knn_cm <- confusionMatrix(knn_pred, test$result)
print(knn_cm)

# KNN 혼동 행렬 데이터프레임으로 변환
knn_cm_df <- as.data.frame(knn_cm$table)

# KNN 혼동 행렬 시각화
ggplot(knn_cm_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 6) +
  scale_fill_gradient(low = "#99CCFF", high = "#FF9999") +
  labs(title = "Confusion Matrix for KNN", x = "Predicted", y = "Actual") +
  theme_minimal()


### SVM 모델 학습 및 예측 ###
# SVM 모델 학습 # 
svm_model <- svm(result ~ ., data=train)

# 예측 # 
svm_pred <- predict(svm_model, test)

# 성능 평가 # 
confusionMatrix(svm_pred, test$result)

# SVM 모델의 혼동 행렬
svm_cm <- confusionMatrix(svm_pred, test$result)
print(svm_cm)

# SVM 혼동 행렬 데이터프레임으로 변환
svm_cm_df <- as.data.frame(svm_cm$table)

# SVM 혼동 행렬 시각화
ggplot(svm_cm_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 6) +
  scale_fill_gradient(low = "#99CCFF", high = "#FF9999") +
  labs(title = "Confusion Matrix for SVM", x = "Predicted", y = "Actual") +
  theme_minimal()



### 모델 성능 비교 ###
# KNN과 SVM 예측 결과 비교 #
results <- data.frame( 
  Actual = test$result, 
  KNN_Predicted = knn_pred, 
  SVM_Predicted = svm_pred
  )

print(results)


### 모델 정확도 비교 ###
# KNN과 SVM 정확도 비교 # 
knn_acc <- sum(knn_pred == test$result) / nrow(test)
svm_acc <- sum(svm_pred == test$result) / nrow(test)

accuracy_df <- data.frame(
  Model = c("KNN", "SVM"), 
  Accuracy = c(knn_acc, svm_acc)
)

# 정확도 시각화
ggplot(accuracy_df, aes(x = Model, y = Accuracy, fill = Model)) +
  geom_bar(stat = "identity", width = 0.6) +
  ylim(0, 1) +
  labs(title = "Comparison of KNN and SVM Accuracy", 
       x = "Model", y = "Accuracy") +
  theme_minimal()
