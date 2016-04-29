import pyRserve
import re

RINIT = """
library(deployr)
service = get(load("%s"))
"""

RPREDICT = """
print(service)
endpoint = get_endpoint(service, "%s")
print(endpoint)
"""

class Service(object):

	"""
	This object communicates with an R-service made with 
	the deployr package
	"""

	# public methods

	def __init__(self, rdata, rhost="localhost", rport=6311):
		self.rhost = rhost
		self.rdata = rdata
		self.rport = rport

		try:
			self.conn = pyRserve.connect(host = rhost, port = rport)
		except:
			print "Could not connect to host"
			raise

		self._init_r_session()

	def predict(self, endpoint, data):

		self.conn.eval("endpoint = get_endpoint(service, \"%s\")" % endpoint)
		self.conn.r.data = data
		return self.conn.eval("predict(endpoint, data)")

	def list_endpoints(self):
		return self.conn.eval("list_endpoints(service)")

	# private methods

	def _init_r_session(self):
		self.conn.eval("library(deployr)")
		self.conn.eval("service = get(load(\"%s\"))" % self.rdata)




	


if __name__ == "__main__":
	service = Service("/Users/Eric/Projects/deployr/iris_service.Rdata")

	f = open("../../iris.json")

	lines = ""
	for line in f:
		line = re.sub("[\n\t ]", "", line)
		lines += re.sub('"', r'\"', line)
	lines = '"' + lines + '"'
	print lines
	print service.predict("iris", lines)