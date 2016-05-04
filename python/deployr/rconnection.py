import pyRserve
from pyRserve.rexceptions import RConnectionRefused
import logging
import os

class RConnection(object):

	def __init__(self, conn):
		self.conn = conn
		self.r = conn.r

	def eval(self, cmd):
		return self.conn.eval(cmd)

	def assign(self, key, value):
		setattr(self.conn.r, key, value)


class RConnectionBuilder(object):

	def __init__(self, port = 6311, host = 'localhost'):
		self.port = int(port)
		self.host = str(host)

		try:
			self.conn = pyRserve.connect(host = host, port = port)
		except RConnectionRefused:
			# try to start Rserver on localhost if possible
			if host == "localhost":
				os.system("R CMD Rserve --RS-port %i --no-save" % port)
				self.conn = pyRserve.connect(host = host, port = port)
			else:
				raise RConnectionRefused

		res = self.conn.eval("1+1")
		if res != 2:
			raise IOError("Unable to execute on R connection")

	def __call__(self):
		conn = pyRserve.connect(host = self.host, port = self.port)

		if self.conn.eval("1+1") != 2:
			raise IOError("Unable to execute on R connection")

		return RConnection(conn)

if __name__ == "__main__":
	rbuilder = RConnectionBuilder()
	rconn = rbuilder()

