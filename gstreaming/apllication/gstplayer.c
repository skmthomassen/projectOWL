#include <gst/gst.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <dirent.h>

static GMainLoop *loop;

GstElement *pipeline;
GstElement *filesrc;
GstMessage *msg;
GstBus *bus;
GError *error = NULL;
GstSeekFlags seek_flags = GST_SEEK_FLAG_FLUSH | GST_SEEK_FLAG_KEY_UNIT;

int fifo;
char buf[128] = "";
char fifo_name[] = "gst.fifo";
char files[255][255];
int currently_playing;
guint bus_watch_id;

void play_next();
void player_play(char *filename);
void player_pause(void){gst_element_set_state(pipeline, GST_STATE_PAUSED);}
void player_resume(void){gst_element_set_state(pipeline, GST_STATE_PLAYING);}
void player_seek_absolute(int position){gst_element_seek (pipeline, 1.0,
		  GST_FORMAT_TIME,
		  seek_flags,
		  GST_SEEK_TYPE_SET, position * GST_SECOND,
		  GST_SEEK_TYPE_NONE, GST_CLOCK_TIME_NONE); }
void player_stop(void){gst_element_set_state (pipeline, GST_STATE_NULL);
			gst_object_unref (GST_OBJECT (pipeline));
			pipeline = NULL;
			g_source_remove(bus_watch_id);}

bus_callback (GstBus * bus, GstMessage * message, gpointer data){
	switch (GST_MESSAGE_TYPE (message)) {
		case GST_MESSAGE_EOS:
			play_next();
			break;
	}
	return TRUE;
}

void play_next(){
	if(currently_playing >= 0) {
		if(strcmp(files[currently_playing+1], "") == 0) {
			currently_playing = 0;
		} else {currently_playing++;}
		player_play(files[currently_playing]);
	}
}

void player_play(char *filename){
	printf("Now playing %s\n", filename);
	// Destroy previous pipeline
	if(pipeline) {
		player_stop();
	}
	// Create new pipeline
	pipeline = gst_parse_launch("matroskamux name=mux ! filesink location=trymefirst.mkv \
  rtspsrc location=URL_A RTSPSRC_SETTINGS \
  ! queue ! capsfilter caps=\"application/x-rtp,media=video\" \
  ! rtph264depay ! h264parse ! mux.video_0 \
  rtspsrc location=URL_B RTSPSRC_SETTINGS  \
  ! queue ! capsfilter caps=\"application/x-rtp,media=video\" \
  ! rtph264depay ! h264parse ! mux.video_1 &", &error);

	if(!pipeline) {
		printf("Parse error: %s\n", error->message);
		exit(1);
	}

	// Listen for messages/events
	bus = gst_pipeline_get_bus (GST_PIPELINE (pipeline));
	bus_watch_id = gst_bus_add_watch (bus, bus_callback, loop);
	gst_object_unref (bus);

	// Set filename on pipeline, and start playing

	URLA = rtsp://root:hest1234@192.168.130.200/axis-media/media.amp
	URLB = rtsp://root:hest1234@192.168.130.201/axis-media/media.amp
	RTSPSRC_SETTINGS = ntp-sync=true protocols=GST_RTSP_LOWER_TRANS_TCP

	rtspsrc = gst_bin_get_by_name(GST_BIN (pipeline), "URL_A");
	g_object_set(rtspsrc, "location", filename, NULL);

	filesrc = gst_bin_get_by_name(GST_BIN (pipeline), "my_filesrc");
	g_object_set(filesrc, "location", filename, NULL);
	gst_element_set_state(pipeline, GST_STATE_PLAYING);
}

void read_files(){
	DIR *dir;
	struct dirent *ent;
	dir = opendir ("/home/kim/projectOWL/gstreaming/apllication/clips");
	if (dir != NULL) {
		int i = 0;
		while ((ent = readdir (dir)) != NULL) {
			if(strncmp(ent->d_name, ".", 1024) > 0 && strncmp(ent->d_name, "..", 1024) > 0) {
				sprintf(files[i], "/home/kim/projectOWL/gstreaming/apllication/clips%s", ent->d_name);
				i++;
			}
		}
		strcpy(files[i+1], "");
	}
	int n = 0;
	while(strcmp(files[n], "") != 0) {
		printf("File %d: %s\n", n, files[n]);
		n++;
	}
	printf("Found %d files\n", sizeof(files));
}

gboolean timeout(gpointer data){
	fifo = open(fifo_name, O_RDONLY | O_NONBLOCK);
	memset(buf, 0, strlen(buf));
	if(read(fifo, &buf, sizeof(char)*128) > 0)	{
		size_t ln = strlen(buf) - 1;
		if (buf[ln] == '\n')
			buf[ln] = '\0';
		if(strcmp(buf, "pause") == 0) {
			if(pipeline->current_state == GST_STATE_PLAYING) {
				player_pause();
			} else if(pipeline->current_state == GST_STATE_PAUSED) {
				player_resume();
			}
		} else if(strstr( buf, "seek" ) != NULL) {
			char position[10];
			memcpy( position, &buf[5], 10 );
			player_seek_absolute( atoi( position ) );
		} else if(strstr( buf, "stop" ) != NULL) {
			if(pipeline->current_state == GST_STATE_PLAYING || pipeline->current_state == GST_STATE_PAUSED) {player_stop();}
		} else if(strstr( buf, "next" ) != NULL) {
			if(pipeline->current_state == GST_STATE_PLAYING || pipeline->current_state == GST_STATE_PAUSED) {play_next();}
		} else if(strstr(buf, "play") != NULL) {
			// Get filename and path
			char content_identifier[128];
			char filename[128];
			memcpy( content_identifier, &buf[5], 122);
			sprintf(filename, "/home/kim/projectOWL/gstreaming/apllication/clips%s.mkv", content_identifier);
			player_play(filename);
		}
	}
	close(fifo);
	return TRUE;
}

int main(int argc, char *argv[]){
	read_files();
 	gst_init(&argc, &argv);
	g_timeout_add(500, timeout, NULL);
	loop = g_main_loop_new (NULL, FALSE);
	currently_playing = 0;
	player_play(files[currently_playing]);
	g_main_loop_run (loop);
	g_main_loop_quit(loop);
	gst_element_set_state (pipeline, GST_STATE_NULL);
	gst_object_unref (pipeline);
	gst_message_unref (msg);
	return 0;
}
