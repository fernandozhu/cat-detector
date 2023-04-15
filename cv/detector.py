from ultralytics import YOLO
from ultralytics.yolo.v8.detect.predict import DetectionPredictor

model = YOLO("yolov8m.pt")

results = model.predict(source="1", show=True, save=True)
results.orig_img

print(results[0].name)
