package com.cg.controller;

import com.cg.model.Customer;
import com.cg.service.CustomerService;
import com.cg.service.ICustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/customers")
public class CustomerController {
    private ICustomerService customerService = new CustomerService();
    @GetMapping("/list")
    public String showListPage(Model model) {
        List<Customer>customerList= customerService.findAll();
        model.addAttribute("customers",customerList);
        return "customer/list";
    }
//    public ModelAndView showListPage() {
//        ModelAndView modelAndView = new ModelAndView();
//        modelAndView.setViewName("customer/list");
//        return modelAndView;
//    }

    @GetMapping("/info")
    public String showInfoPage() {
        return "customer/info";
    }

    @GetMapping("/create")
    public String showCreatePage(Model model) {
        model.addAttribute("customer",new Customer());
        return "customer/create";
    }
    @PostMapping("/save")
    public String save(Customer customer) {
        customer.setId((int) (Math.random()*1000));
        customerService.save(customer);
        return "redirect:/customers/list";
    }

}
