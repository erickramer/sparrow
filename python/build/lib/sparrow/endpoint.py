import pyRserve
import numpy
from flask import json
import time

class Endpoint(object):

	"""
	This is a python class that interacts with
	each R endpoint intependently
	"""

	def __init__(self, conn_builder, data, name):
		self.conn = conn_builder()
		self.name = name
		self.data = data
		self.n_calls = 0
		self.predictions = []
		self.prediction_data = []
		self.init_r_session()

	def predict(self, data):
		# housekeeping
		start_time = time.time()
		self.n_calls += 0

		self.prediction_data.append(data)

		# run prediction
		self.conn.assign("data", data)
		result = self.conn.eval("predict(myendpoint, data)")
		end_time = time.time()

		
		result_dict = {
						'metadata': 
							{
								'start_time' : start_time,
								'end_time' : end_time
							},
						'prediction': json.loads(result)
						}

		self.predictions.append(result_dict)

		return result

	def model_class(self):
		return self.conn.eval("class(myendpoint)")

	def schema(self):
		classes = self.conn.eval("myendpoint$input_schema$classes")
		xlevels = self.conn.eval("myendpoint$input_schema$xlevels")

		return {
				'classes': convert_schema(classes), 
				'xlevels': convert_schema(xlevels)
				}

	def n_calls(self):
		return self.n_calls

	def summary(self):
		return {
				'name': self.name, 
				'class': self.model_class()[0],
				'status': self.status()
				}

	def init_r_session(self):
		self.conn.eval("library(sparrow)")
		self.conn.eval("myservice = get(load(\"%s\"))" % self.data)
		self.conn.eval("myendpoint = get_egg(myservice, \"%s\")" % self.name)

	def status(self):
		if self.conn.eval("1+1") == 2:
			return 'ok'
		else:
			return 'not ok'

	def model_summary(self):
		return self.conn.eval("model_summary(myendpoint)").decode("utf-8")

def convert_schema(obj):

	if isinstance(obj, pyRserve.TaggedList):
		obj = dict(obj.astuples())

		new_obj = {}
		for key, value in obj.iteritems():
			if isinstance(value, numpy.ndarray):
				value = value.tolist() 
			new_obj[key] = value
		return new_obj
	elif isinstance(obj, pyRserve.TaggedArray):
		values = obj.tolist()
		keys = obj.keys()
		return zip(keys, values)
