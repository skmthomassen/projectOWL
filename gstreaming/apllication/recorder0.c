#include <gst/gst.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

  GMainLoop *loop;

  /* Initialize GStreamer */
  gst_init (&argc, &argv);

  GstElement *pipeline;
  GstMessage *msg;
  GstBus *bus;
  GError *error = NULL;
  guint bus_watch_id;

  GstElement *rtspsrc;
  GstElement *matroskamux;
  GstElement *filesink;
  GstElement *rtph264depay;
  GstElement *h264parse;
  GstElement *queue;
  GstElement *capsfilter;

/*
  string URL_A = "rtsp://root:hest1234@192.168.130.200/axis-media/media.amp"
  string URL_B = "rtsp://root:hest1234@192.168.130.201/axis-media/media.amp"
  string RTSPSRC_SETTINGS = "ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP"
*/

  //gst_element_set_state (pipeline, GST_STATE_NULL);

	// Create new pipeline
	pipeline = gst_parse_launch("matroskamux name=mux ! filesink location=trymefirst.mkv \
  rtspsrc location=rtsp://root:hest1234@192.168.130.200/axis-media/media.amp ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP \
  ! queue ! capsfilter caps=\"application/x-rtp,media=video\" \
  ! rtph264depay ! h264parse ! mux.video_0 \
  rtspsrc location=rtsp://root:hest1234@192.168.130.201/axis-media/media.amp ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP  \
  ! queue ! capsfilter caps=\"application/x-rtp,media=video\" \
  ! rtph264depay ! h264parse ! mux.video_1 &", &error);

	if(!pipeline) {
		printf("Parse error: %s\n", error->message);
		exit(1);
	}
  // Listen for messages/events
  bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
  gst_object_unref (bus);

  // Set pipeline to playing
  gst_element_set_state(pipeline, GST_STATE_PLAYING);

  g_main_loop_run(loop);

//









}
