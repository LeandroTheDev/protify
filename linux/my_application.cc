#include <math.h>
#include <upower.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication
{
  GtkApplication parent_instance;
  char **dart_entrypoint_arguments;
  // Bobodev: Creating the screen resolution method
  FlMethodResponse *get_screen_resolution;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Bobodev: The actual function to retrieve the screen resolution
static FlMethodResponse *get_screen_resolution()
{
  Display *display = XOpenDisplay(NULL);
  if (!display)
  {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "UNAVAILABLE", "Failed to open X display.", nullptr));
  }

  int screen = DefaultScreen(display);
  Window root = RootWindow(display, screen);

  XWindowAttributes window_attributes;
  if (!XGetWindowAttributes(display, root, &window_attributes))
  {
    XCloseDisplay(display);
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "UNAVAILABLE", "Failed to get window attributes.", nullptr));
  }

  int width = window_attributes.width;
  int height = window_attributes.height;

  XCloseDisplay(display);

  g_autoptr(FlValue) result = fl_value_new_map();
  fl_value_set_int(result, "width", width);
  fl_value_set_int(result, "height", height);

  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

// Bobodev: The handler for resolution receiving messages from flutter
static void resolution_method_call_handler(FlMethodChannel *channel, FlMethodCall *method_call, gpointer user_data)
{
  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(fl_method_call_get_name(method_call), "getScreenResolution") == 0)
  {
    response = get_screen_resolution();
  }
  else
  {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error))
  {
    g_warning("Failed to send response: %s", error->message);
  }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication *application)
{
  MyApplication *self = MY_APPLICATION(application);
  GtkWindow *window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Bobodev: Getting the actual screen resolution
  GdkScreen *screen = gtk_window_get_screen(window);
  gint screen_width = gdk_screen_get_width(screen);
  gint screen_height = gdk_screen_get_height(screen);

  gboolean use_header_bar = TRUE;
// Bobodev: X11 support
#ifdef GDK_WINDOWING_X11
  GdkScreen *screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen))
  {
    const gchar *wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0)
    {
      use_header_bar = FALSE;
    }
  }
#endif
// Bobodev: Wayland support
#ifdef GDK_WINDOWING_WAYLAND
  if (GDK_IS_WAYLAND_DISPLAY(screen))
  {
    // make Wayland support here
  }
  else
#endif
    if (use_header_bar)
    {
      GtkHeaderBar *header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
      gtk_widget_show(GTK_WIDGET(header_bar));
      gtk_header_bar_set_title(header_bar, "protify");
      gtk_header_bar_set_show_close_button(header_bar, TRUE);
      gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
    }
    else
    {
      gtk_window_set_title(window, "protify");
    }

  // Bobodev: Getting the half size of the scree size
  gint half_screen_width = round((float)screen_width / 2);
  gint half_screen_height = round((float)screen_height / 2);

  // Bobodev: Defining the screen size
  gtk_window_set_default_size(window, half_screen_width, half_screen_height);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView *view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Bobodev: Methods Registry Start
  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Bobodev: Registering the Resolution Method
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->get_screen_resolution = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "samples.flutter.dev/resolution", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      self->get_screen_resolution, resolution_method_call_handler, self, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(view));
  // Bobodev: Methods Registry End
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication *application, gchar ***arguments, int *exit_status)
{
  MyApplication *self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error))
  {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GObject::dispose.
static void my_application_dispose(GObject *object)
{
  MyApplication *self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  // Bobodev: Disposing the screen resolution method
  g_clear_object(&self->get_screen_resolution);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass *klass)
{
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication *self) {}

MyApplication *my_application_new()
{
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}