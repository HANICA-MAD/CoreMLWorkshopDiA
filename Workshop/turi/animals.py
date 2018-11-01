import turicreate as turi
import os

#Deze functie geeft de most derived map naam van een pad.
def getLabelFromPath(path):
    return os.path.basename(os.path.dirname(os.path.normpath(path)))

#Voorbeeld ophalen data en laten zien
myPath = 'datasets'

data = turi.image_analysis.load_images(myPath,with_path = True, recursive = True)

data["animals"] = data["path"].apply(lambda path: getLabelFromPath(path))

print(data.groupby("animals",[turi.aggregate.COUNT]))

data.save("animals.sframe")

#Laat je data zien in UI, mooie controle of alles wel correct is opgehaald.
#data.explore()

#Model trainen, 10% training data , 90% test data
train_data, test_data = data.random_split(0.9)

#create a model
model = turi.image_classifier.create(train_data, target="animals")

predictions = model.predict(test_data)
print(predictions)
#evalute model
metrics = model.evaluate(test_data)

print(metrics["accuracy"])
print("Saving model")
model.save("animal.model")
print("Saving core ml model")
model.export_coreml("animals.mlmodel")
print("Done")

