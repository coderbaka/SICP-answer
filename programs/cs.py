#!/usr/bin/python

'''
A simple constrait seperator described in SICP
'''

import abc


class Constrait(abc.ABC):

    @abc.abstractmethod
    def inform_value_change(self):
        '''When a connector's value has changed,it will call this method,so that Constrait can set other connectors' value'''

    @abc.abstractmethod
    def inform_value_forget(self):
        '''When a connector's value has forgotten,it will call this method,so that Constrait can forget other connectors' value'''


class Connector():

    def __init__(self):
        self._value = 0
        self._constraits = set()
        self._has_value = False

    def set_value(self, value, setter):
        if not self._has_value or self._value != value:
            self._value = value
            self._has_value = True
            for constrait in self._constraits:
                if setter != constrait:
                    constrait.inform_value_change()

    def get_value(self):
        return self._value

    def has_value(self):
        return self._has_value

    def forget_value(self, setter):
        self._has_value = False
        for constrait in self.constraits:
            if setter != constrait:
                constrait.inform_value_forget()

    def connect(self, constrait):
        self._constraits.add(constrait)


class Adder(Constrait):

    def __init__(self, a1, a2, sum):
        self._a1 = a1
        self._a2 = a2
        self._sum = sum
        self._a1.connect(self)
        self._a2.connect(self)
        self._sum.connect(self)

    def inform_value_change(self):
        if self._a1.has_value() and self._a2.has_value():
            self._sum.set_value(self._a1.get_value() +
                                self._a2.get_value(), self)
        elif self._a1.has_value() and self._sum.has_value():
            self._a2.set_value(self._sum.get_value() -
                               self._a1.get_value(), self)
        elif self._a2.has_value() and self._sum.has_value():
            self._a1.set_value(self._sum.get_value() -
                               self._a2.get_value(), self)

    def inform_value_forget(self):
        self._a1.forget_value(self)
        self._a2.forget_value(self)
        self._sum.forget_value(self)


class Multipier(Constrait):

    def __init__(self, a1, a2, product):
        self._a1 = a1
        self._a2 = a2
        self._product = product
        a1.connect(self)
        a2.connect(self)
        product.connect(self)

    def inform_value_change(self):
        if (self._a1.has_value() and self._a1.get_value() == 0) or \
                (self._a2.has_value() and self._a2.get_value() == 0):
            self._product.set_value(0, self)
        elif self._a1.has_value() and self._a2.has_value():
            self._product.set_value(
                self._a1.get_value() * self._a2.get_value(), self)
        elif self._a1.has_value() and self._product.has_value():
            self._a2.set_value(self._product.get_value() /
                               self._a1.get_value(), self)
        elif self._a2.has_value() and self._product.has_value():
            self._a1.set_value(self._product.get_value() /
                               self._a2.get_value(), self)

    def inform_value_forget(self):
        self._a1.forget_value(self)
        self._a2.forget_value(self)
        self._product.forget_value(self)
        self.inform_value_change()


class Constant(Constrait):

    def __init__(self, connector, value):
        self._connector = connector
        connector.set_value(value, self)

    def inform_value_change(self):
        raise ValueError("Cannot change a constant connector")

    def inform_value_forget(self):
        raise ValueError("Cannot forget a constant connector")


class Probe(Constrait):

    def __init__(self, name, connector):
        self._connector = connector
        self._name = name
        connector.connect(self)

    def inform_value_forget(self):
        print(f"Connector {self._name} now is ?")

    def inform_value_change(self):
        print(f"Connector {self._name} now is {self._connector.get_value()}")


def average(a, b, c):
    u1 = Connector()
    u2 = Connector()
    Adder(a, b, u1)
    Constant(u2, 0.5)
    Multipier(u1, u2, c)


if __name__ == '__main__':
    pass
