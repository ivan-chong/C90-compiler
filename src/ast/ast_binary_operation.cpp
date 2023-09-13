#include "ast/ast_binary_operation.hpp"

BinaryOperation::BinaryOperation(BaseExpression* _left, BaseExpression* _right)
    : left(_left), right(_right) {};

BinaryOperation::~BinaryOperation() {
    delete left;
    delete right;
};

int BinaryOperation::prepLeft(std::ostream& os, Context& context, int destReg) const {

    // check if left is a function call - then allocate a callee saved reg eg s1
    int left_reg = context.allocateReg();
    context.useReg(left_reg);
    left->compile(os, context, left_reg);

    return left_reg;

};
int BinaryOperation::prepRight(std::ostream& os, Context& context, int destReg) const{

    int right_reg = context.allocateReg();
    context.useReg(right_reg);
    right->compile(os, context, right_reg);

    return right_reg;

};

void BinaryOperation::compile(std::ostream& os, Context& context, int destReg) const {
    std::cerr << "Error: compile() should not be called on a BinaryOperation object" << std::endl;
};