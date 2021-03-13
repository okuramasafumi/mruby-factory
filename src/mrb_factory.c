/*
** mrb_factory.c - Factory class
**
** Copyright (c) OKURA Masafumi 2021
**
** See Copyright Notice in LICENSE
*/

#include "mruby.h"
#include "mruby/data.h"
#include "mrb_factory.h"

#define DONE mrb_gc_arena_restore(mrb, 0);

typedef struct {
  char *str;
  mrb_int len;
} mrb_factory_data;

static const struct mrb_data_type mrb_factory_data_type = {
  "mrb_factory_data", mrb_free,
};

static mrb_value mrb_factory_init(mrb_state *mrb, mrb_value self)
{
  mrb_factory_data *data;
  char *str;
  mrb_int len;

  data = (mrb_factory_data *)DATA_PTR(self);
  if (data) {
    mrb_free(mrb, data);
  }
  DATA_TYPE(self) = &mrb_factory_data_type;
  DATA_PTR(self) = NULL;

  mrb_get_args(mrb, "s", &str, &len);
  data = (mrb_factory_data *)mrb_malloc(mrb, sizeof(mrb_factory_data));
  data->str = str;
  data->len = len;
  DATA_PTR(self) = data;

  return self;
}

static mrb_value mrb_factory_hello(mrb_state *mrb, mrb_value self)
{
  mrb_factory_data *data = DATA_PTR(self);

  return mrb_str_new(mrb, data->str, data->len);
}

static mrb_value mrb_factory_hi(mrb_state *mrb, mrb_value self)
{
  return mrb_str_new_cstr(mrb, "hi!!");
}

void mrb_mruby_factory_gem_init(mrb_state *mrb)
{
  struct RClass *factory;
  factory = mrb_define_class(mrb, "Factory", mrb->object_class);
  mrb_define_method(mrb, factory, "initialize", mrb_factory_init, MRB_ARGS_REQ(1));
  mrb_define_method(mrb, factory, "hello", mrb_factory_hello, MRB_ARGS_NONE());
  mrb_define_class_method(mrb, factory, "hi", mrb_factory_hi, MRB_ARGS_NONE());
  DONE;
}

void mrb_mruby_factory_gem_final(mrb_state *mrb)
{
}

