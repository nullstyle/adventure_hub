- Stream:  a progression of continually changing values
  - Sensor stream: a stream driven from a sensor of some kind: GPS, Video, Camera lense, Clock
  - Derived stream: a stream derived from a sensor stream that has had a filter applied to it.  For example, a ring buffer filter could be applied to a video stream to provide a stream that can be sampled to retrieve the last 5 minutes of video as a sample.

- Sample:  a persisted value take from a given stream and attached to a timestamp
