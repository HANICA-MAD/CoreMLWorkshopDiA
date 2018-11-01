import coremltools
from coremltools.models.neural_network.quantization_utils import *
model = coremltools.models.MLModel('/Users/agit/Desktop/DiA/repository/dia-nj-2018-agit-tunc/Workshop/coremltools/Inceptionv3.mlmodel')
lin_quant_model = quantize_weights(model, 16, "linear")
lin_quant_model.save('/Users/agit/Desktop/DiA/repository/dia-nj-2018-agit-tunc/Workshop/coremltools/QuantizedInceptionv3.mlmodel')

lut_quant_model = quantize_weights(model, 16, "kmeans")
#test our model with some test data
compare_models(model, lin_quant_model, '/Users/agit/Desktop/DiA/repository/dia-nj-2018-agit-tunc/Workshop/coremltools/sampleimages')
