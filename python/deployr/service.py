import pyRserve
import re
from rconnection import RConnectionBuilder
from endpoint import Endpoint

class Service(object):

	"""
	This object communicates with an R-service made with 
	the deployr package
	"""

	# public methods

	def __init__(self, conn_builder, data):

		self.conn_builder = conn_builder

		self.conn = conn_builder() # establish connection for service
		self.data = data

		self.init_r_session()
		self.build_endpoints()

	def predict(self, endpoint, data):
		return self.get_endpoint(endpoint).predict(data)

	def list_endpoints(self):
		endpoints = self.conn.eval("list_endpoints(myservice)")
		if isinstance(endpoints, str):
			return [endpoints]
		else:
			return endpoints

	def get_endpoint(self, name):
		return self.endpoints[name]

	# private methods

	def init_r_session(self):
		self.conn.eval("library(deployr)")
		self.conn.eval("myservice = get(load(\"%s\"))" % self.data)

	def build_endpoints(self):
		names = self.list_endpoints()
		self.endpoints = {}

		for name in names:
			self.endpoints[name] = Endpoint(self.conn_builder, self.data, name)

	def rport(self):
		pass

	def pyport(self):
		pass

	def rurl(self):
		pass




if __name__ == "__main__":
	builder = RConnectionBuilder()

	s = Service(builder, "/Users/Eric/Projects/deployr/iris.Rdata")
