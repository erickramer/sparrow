import pyRserve

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
		return None

	def n_calls(self):
		return self.n_calls

	def init_r_session(self):
		self.conn.eval("library(deployr)")
		self.conn.eval("myservice = get(load(\"%s\"))" % self.data)
		self.conn.eval("myendpoint = get_endpoint(myservice, \"%s\")" % self.name)