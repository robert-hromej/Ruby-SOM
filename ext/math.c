#include "ruby.h"

static VALUE euclidean_distance(VALUE self, VALUE point1, VALUE point2) {
    double result = 0, tmp = 0;

    long i, dimension = RARRAY_LEN(point1);

    VALUE *x1 = RARRAY_PTR(point1);
    VALUE *x2 = RARRAY_PTR(point2);

    for(i=0; i < dimension; i++) {
      tmp = (NUM2DBL(x1[i]) - NUM2DBL(x2[i]));
      result += tmp*tmp;
    }

    return rb_float_new(result);
}

static VALUE closest(VALUE self, VALUE data, VALUE data_item) {
    long min_index = 0;
    double current_distance, min_distance = 99999999;

    long i, size = RARRAY_LEN(data);

    VALUE *_data = RARRAY_PTR(data);

    for(i = 0; i < size; i++) {
       current_distance = euclidean_distance(self, _data[i], data_item);
        if (current_distance < min_distance){
            min_distance = current_distance;
            min_index = i;
        }
    }
    return rb_int_new(min_index);
}


static VALUE update_weights(VALUE self, VALUE _weights, VALUE _data, VALUE _rate) {
    VALUE result = rb_ary_new();

    long i, dimension = RARRAY_LEN(_weights);

    double rate = NUM2DBL(_rate), weight;

    VALUE *weights = RARRAY_PTR(_weights);
    VALUE *data = RARRAY_PTR(_data);

    for(i=0; i < dimension; i++) {
        weight = NUM2DBL(weights[i]) + rate * ( NUM2DBL(data[i]) - NUM2DBL(weights[i]));
        rb_ary_push(result, rb_float_new(weight));
    }

    return result;
}


void Init_math(void) {
  VALUE math_module = rb_define_module("Math");
  rb_define_singleton_method(math_module, "euclidean_distance", euclidean_distance, 2);
  rb_define_singleton_method(math_module, "closest", closest, 2);
  rb_define_singleton_method(math_module, "update_weights", update_weights, 3);
}