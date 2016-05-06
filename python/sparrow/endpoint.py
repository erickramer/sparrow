import pyRserve
import numpy

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

		self.init_r_session()

	def predict(self, json):
		self.n_calls += 0
		self.conn.assign("data", json)
		self.conn.eval("show(myendpoint)")
		return self.conn.eval("predict(myendpoint, data)")

	def model_class(self):
		return self.conn.eval("class(myendpoint)")

	def schema(self):
		classes = self.conn.eval("myendpoint$classes")
		xlevels = self.conn.eval("myendpoint$xlevels")

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
		self.conn.eval("library(deployr)")
		self.conn.eval("myservice = get(load(\"%s\"))" % self.data)
		self.conn.eval("myendpoint = get_endpoint(myservice, \"%s\")" % self.name)

	def status(self):
		if self.conn.eval("1+1") == 2:
			return 'ok'
		else:
			return 'not ok'

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
