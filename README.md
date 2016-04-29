# Deployr: deploying R models as a REST API

This is an experiment trying to deploy R models as a REST APIs. Users can create services, each with a set of endpoints. The endpoints represent models that receive and return JSON.


## Install

Deployr has a lot of dependencies. Maybe I can automate the install somehow.

#### Install Flask

(command line)

```
pip install flask
```

#### Install Rserve
(in R prompt)

```
install.packages("Rserve")
```

#### Install R package
(in R prompt)

```
library(devtools)
install_github("erickramer/deployr/rpkg")
```

#### Install Python Module

?


## Use

The goal is to make deploying models as REST APIs easy.

First we create an endpoint from a model. Then we add that endpoint to a service

```
ep1 = lm(Sepal.Length ~ ., data=iris) %>%
 endpoint()

s = service() %>%
	add_endpoints(sepal_length = ep1) %>%
	deploy(port = 1111)

```

Now our linear model should be running on port 1111. 