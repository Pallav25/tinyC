
// Function prototypes for testing argument-expression-list and function calls
void example_function(int a, float b);
static int static_var = 0; // Example of static storage class
inline int add(int a, int b);               // Inline function (function-specifier)
void test_pointers(const int *ptr);         // Pointer with const qualifier
       // Array parameter with static
int sum(int count, ...);               // Function with variadic parameters

// Declaration specifiers with various type qualifiers and storage-class specifiers
extern int global_var;                      // extern storage-class specifier
static float static_var = 0.0;              // static storage-class specifier
const int constant_var = 42;                // const qualifier
volatile int volatile_var = 1; 
// Function with pointer return type
int* return_pointer() {
    static int value = 10;  // static variable
    return &value;          // returning address of static variable
}

// Function with parameters
void parameter_example(const char *str, int count) {
    for (int i = 0; i < count; i++) {
        printf("%s ", str); // Prints the string count times
    }
    printf("\n");
}
void test_iteration_statements() {
    int i = 0;

    // Testing while loop
    while (i < 3) {
        printf("While Loop Iteration: %d\n", i);
        i++;
    }

    // Resetting i for the next test
    i = 0;

    // Testing do-while loop
    do {
        printf("Do-While Loop Iteration: %d\n", i);
        i++;
    } while (i < 3);

    // Testing for loop
    for (int j = 0; j < 3; j++) {
        printf("For Loop Iteration (expr; expr; expr): %d\n", j);
    }

    // Testing for loop with declaration inside
    for (int j = 0; j < 3; j++) {
        printf("For Loop Iteration (declaration; expr; expr): %d\n", j);
    }
}



void test_jump_statements() {
    int i;

    // Testing goto statement
    goto_label:
        printf("This is a 'goto' statement test\n");

    // Testing continue and break inside loop
    for (i = 0; i < 5; i++) {
        if (i == 2) {
            continue;  // Skips iteration when i == 2
        }
        if (i == 4) {
            break;  // Breaks loop when i == 4
        }
        printf("Loop Iteration with continue and break: %d\n", i);
    }

    // Testing return statement
    printf("Testing return statement now...\n");
    return;
}


void escape_sequence_showcase(void) {
    char single_quote = '\'';
    char double_quote = '\"';
    char question_mark = '\?';
    char backslash = '\\';
    char alert = '\a';
    char backspace = '\b';
    char form_feed = '\f';
    char new_line = '\n';
    char carriage_return = '\r';
    char horizontal_tab = '\t';
    char vertical_tab = '\v';

    printf("Escape sequences:\n");
    printf("Single quote: %c\n", single_quote);
    printf("Double quote: %c\n", double_quote);
    printf("Question mark: %c\n", question_mark);
    printf("Backslash: %c\n", backslash);
    printf("Alert (bell): \a\n");
    printf("Backspace: abc\bdef\n");
    printf("Form feed: \f");
    printf("New line: \nNew line demonstrated\n");
    printf("Carriage return: \rCarriage return demonstrated\n");
    printf("Horizontal tab: \tTabbed text\n");
    printf("Vertical tab: \vVertical tab demonstrated\n");

    char* string_with_escapes = "This string contains various escapes: \' \" \? \\ \a \b \f \n \r \t \v";
    printf("%s\n", string_with_escapes);
}


int main() {
    // Testing primary-expression:
    int a = 10;               // identifier
    int b = 20;     
    const char *str = "Hello"; // string-literal
    int c = (b+a);           // Declaration with double
    char d = 'A';                 // Declaration with char
    signed int e = -5;            // Signed integer declaration
    unsigned int f = 5;          
    short e;
    long g;
    float h;
    double i;
    signed j;
    unsigned k;
    int l,m,n,o;
    register int reg_var;                       // register storage-class specifier

               
    
    // Print to check values
    printf("a = %d, b = %d, str = %s, c = %d\n", a, b, str, c);

    // Testing postfix-expression:
    int arr[5] = {1, 2, 3, 4, 5};
    int x = arr[2];         // postfix-expression [ expression ]
    printf("arr[2] = %d\n", x);

    // Function calls (postfix-expression (argument-expression-listopt))
    int sum = add(a, b);    // postfix-expression ( argument-expression-list )
    int diff = subtract(a, b);  // postfix-expression ( argument-expression-list , assignment-expression )
    printf("Sum of a and b: %d, Difference: %d\n", sum, diff);

    
    // Testing postfix-expression ++
    x++;  
    printf("x after increment = %d\n", x);

    // Testing postfix-expression --
    x--;  
    printf("x after decrement = %d\n", x);

    // Testing cast-expression
    float f = (float) a / 2;
    printf("f = %.2f\n", f);

    // Testing multiplicative-expression
    int mult = a * b;  // multiplicative-expression ∗ cast-expression
    int div = b / a;   // multiplicative-expression / cast-expression
    int mod = b % a;   // multiplicative-expression % cast-expression
    printf("Multiplication = %d, Division = %d, Modulo = %d\n", mult, div, mod);

    // Testing unary-expression (++ and --)
    ++a;  
    --a;  
    printf("After unary increment, a = %d; After unary decrement, b = %d\n", a, b);

    // Testing unary-operator: one of &*+-~!
    int neg = -a;  // unary negation
    int not_b = ~b; // bitwise NOT
    b=+a;

    printf("Negation of a = %d, Bitwise NOT of b = %d\n", neg, not_b);

    // Testing sizeof unary-expression
    int size = sizeof a;
    printf("Size of a = %d bytes\n", size);

    // Testing sizeof ( type-name )
    size = sizeof(int);
    printf("Size of int = %d bytes\n", size);

    // Testing unary-operator: * and &
    int *ptr_to_a = &a;  // address-of operator
    printf("Address of a = %p, Value at ptr_to_a = %d\n", ptr_to_a, *ptr_to_a);  // dereferencing operator

    // Testing additive-expression
    int sum_exp = a + b; // additive-expression: additive-expression + multiplicative-expression
    int sub_exp = a - b; // additive-expression: additive-expression - multiplicative-expression
    printf("Sum Expression = %d, Subtraction Expression = %d\n", sum_exp, sub_exp);

    // Testing shift-expression
    int shift_left = a << 1;  // shift-expression << additive-expression
    int shift_right = b >> 1; // shift-expression >> additive-expression
    printf("Shift Left: %d, Shift Right: %d\n", shift_left, shift_right);

    // Testing relational-expression
    int greater = a > b;       // relational-expression > shift-expression
    int less_equal = a <= b;   // relational-expression <= shift-expression
    printf("a > b: %d, a <= b: %d\n", greater, less_equal);

    // Testing equality-expression
    int equal = (a == b);       // equality-expression == relational-expression
    int not_equal = (a != b);   // equality-expression != relational-expression
    printf("a == b: %d, a != b: %d\n", equal, not_equal);

    // Testing AND-expression
    int and_exp = (a > 5) & (b < 30); // AND-expression
    printf("AND Expression: %d\n", and_exp);

    // Testing exclusive-OR-expression
    int xor_exp = (a > 5) ^ (b < 25); // exclusive-OR-expression
    printf("Exclusive OR Expression: %d\n", xor_exp);

    // Testing inclusive-OR-expression
    int or_exp = (a < 15) | (b > 10); // inclusive-OR-expression
    printf("Inclusive OR Expression: %d\n", or_exp);

    int logical_and_result = logical_and_test(a, b); // logical-AND-expression
    printf("Logical AND Result: %d\n", logical_and_result);

    // Testing logical-OR-expression
    int logical_or_result = logical_or_test(a, b); // logical-OR-expression
    printf("Logical OR Result: %d\n", logical_or_result);

    // Testing conditional-expression
    int conditional_result = (a > b) ? a : b; // conditional-expression
    printf("Conditional Result: %d\n", conditional_result);

    c = a + b;        // Assignment operator (=)
    printf("c = a + b: %d\n", c);

    c *= 2;           // Compound assignment operator (*=)
    printf("c *= 2: %d\n", c);

    c /= 5;           // Compound assignment operator (/=)
    printf("c /= 5: %d\n", c);

    c %= 3;           // Compound assignment operator (%=)
    printf("c %%= 3: %d\n", c);  // Use %% for printing %

    a += 5;           // Compound assignment operator (+=)
    printf("a += 5: %d\n", a);

    b -= 10;          // Compound assignment operator (-=)
    printf("b -= 10: %d\n", b);

    a <<= 1;          // Compound assignment operator (<<=)
    printf("a <<= 1: %d\n", a);

    b >>= 1;          // Compound assignment operator (>>=)
    printf("b >>= 1: %d\n", b);

    a &= 3;           // Compound assignment operator (&=)
    printf("a &= 3: %d\n", a);

    b ^= 2;           // Compound assignment operator (^=)
    printf("b ^= 2: %d\n", b);

    b |= 5;           // Compound assignment operator (|=)
    printf("b |= 5: %d\n", b);

    // Testing expression
    int exp_result = (a, b); // expression (evaluates to b)
    printf("Expression Result (a, b): %d\n", exp_result);

    static int static_example = 0; // static storage class example
    static_example++;                // Modifying static variable
    printf("Static example: %d\n", static_example);

    // Testing function declaration
    example_function(a, b);  // Calling function with parameters

    // Testing pointer return type
    int *ptr = return_pointer();
    printf("Pointer returned value: %d\n", *ptr);

    // Testing parameter-type-list with function
    parameter_example("Hello", 3); // Example of parameters in function call

    // Testing more declarations
    register int reg_var = 1;  // Example of register storage class
    printf("Register Variable: %d\n", reg_var);

    
    
    // Return success
    return 0;
}

// Function to test argument-expression-list
int add(int x, int y) {
    return x + y;
}

// Function to test argument-expression-list with multiple arguments
int subtract(int x, int y) {
    return x - y;
}

// Function to multiply two numbers (added for multiplicative expressions)
int multiply(int x, int y) {
    return x * y;
}

int logical_and_test(int x, int y) {
    return (x > 5 && y < 30); // logical-AND-expression
}

// Logical OR test function
int logical_or_test(int x, int y) {
    return (x < 15 || y > 25); // logical-OR-expression
}

void example_function(int a, float b) {
    printf("Inside example_function: a = %d, b = %.2f\n", a, b);
}

void example_function(int a, float b) {
    printf("Inside example_function: a = %d, b = %.2f\n", a, b);
}

// Function demonstrating selection-statement
void switch_example(int value) {
    switch (value) {
        case 1:
            printf("Case 1 executed\n");
            break;
        case 2:
            printf("Case 2 executed\n");
            break;
        default:
            printf("Default case executed\n");
            break;
    }
}

// Function demonstrating iteration-statement
void loop_example() {
    for (int i = 0; i < 5; i++) { // for loop
        printf("Iteration %d\n", i);
    }
    
    int j = 0;
    while (j < 3) { // while loop
        printf("While loop iteration %d\n", j);
        j++;
    }
}

// Function demonstrating jump-statement
void jump_example() {
    int k;
    for (k = 0; k < 5; k++) {
        if (k == 2) {
            continue; // skip the iteration when k == 2
        }
        printf("Jump example iteration %d\n", k);
    }

    return; // return statement
}

void greet() {
    printf("Hello, welcome to the translation unit demonstration!\n");
}

// Function definition for multiplication
int multiply(int x, int y) {
    return x * y; // Function definition with parameters
}

// Declaration example for additional functions
int add(int x, int y); // Function prototype

// Inline function definition (function-specifier)
inline int add(int a, int b) {
    return a + b;
}

// Function to test pointer with const qualifier
void test_pointers(const int *ptr) {
    printf("Pointer value: %d\n", *ptr);
}

// Function to test array with static size


// Function with variadic parameters (using ellipsis)

// Additional function definition (if necessary)
// Uncomment to add this function
/*
int add(int x, int y) {
    return x + y; // Function definition
}
*/