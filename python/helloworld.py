# print hello world
print("hello world")

# create a function called 'main' that prints 'hello world'
def main1():												# note the colon
	print("hello world 1") 									# note the indentation of 1 tab

# call the main function to use it
main1() 													# note no indentaation, so not part of function

# print hello world from a global variable
myVariable = "hello world 2" 								# global scope, no need to define variable type e.g. '$', 'int'
print(myVariable)
def main2():
	print(myVariable)
main2()

# print hello world from a local variable
def main3():
	myVariable = "hello world 3" 							# local scope,   
	print(myVariable)
main3() 													# prints local variable "hello world 3"
print(myVariable) 											# prints global variable "hello world 2"

# create a function that REQUIRES an argument
def main4(hw4):
	print(hw4)
main4("hello world 4") 										# prints string argument passed to main4
main4(myVariable)											# prints global variable "hello world 2"

# create a function that REQUIRES multiple arguments
def add(num1, num2):
	"""returns sum of num1 and num2""" # defines the funciton in a "doc" string 
	return num1 + num2 	
print(add(5, 6))											# return requires print() to print to terminal

# Concatination with +
print("testing" + " the next function")						# strings
print("testing " + str(2)) 									# string + numbers

# repeat output
print("testing...\n" * 2) 									# Print string multipe times
print("testing" + "!" * 5) 									# notice "*" is evaluated first


# Converting between numbers + strings
print(int(1.23)) # convert to integer
print(str(1.23)) # convert to string
print(float(1)) # convert to float

# To take user input
print("Hello, what is your name?")
name = input()
print("Nice to meet you " + name)
print("There are " + str(len(name)) + " letters in your name")