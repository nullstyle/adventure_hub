# Event
- type:  Movie, Photo, Track, Waypoint, Voice Recording, Data Log
- hash?: md5 of the content, to deal with re-imports.
- created_at: when this object was inserted into the db
- began_at: the point in time this event began occuring
- ended_at: the point in time this event ended.  Optional, to signify instantaneous events
- #lerp(at): This method allows you to pull a value out of a given event at the specified time, provided the event was occuring at that time.

