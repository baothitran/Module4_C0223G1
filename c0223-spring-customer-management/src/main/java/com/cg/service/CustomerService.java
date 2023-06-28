package com.cg.service;

import com.cg.model.Customer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerService implements ICustomerService{
private static final Map<Integer,Customer> customers;
static {
    customers=new HashMap<>();
    customers.put(1,new Customer(1,"Thi","thi@gmail.com","0789654123","Huế"));
    customers.put(2,new Customer(2,"Hoàn","hoan@gmail.com","0789654124","Hà Nội"));
    customers.put(3,new Customer(3,"Đạt","dat@gmail.com","0789654125","Đà Nẵng"));
    customers.put(4,new Customer(4,"Pháp","phap@gmail.com","0789654126","Quảng Trị"));
}
    @Override
    public List<Customer> findAll() {
        return new ArrayList<>(customers.values());
    }

    @Override
    public void save(Customer customer) {
    customers.put(customer.getId(), customer);

    }

    @Override
    public Customer findById(int id) {
        return customers.get(id);
    }

    @Override
    public void update(int id, Customer customer) {
        customers.put(id,customer);
    }

    @Override
    public void remove(int id) {
        customers.remove(id);
    }
}
