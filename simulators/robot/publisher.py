import argparse, json, random, time, os
from google.cloud import pubsub_v1

def gen_event(robot_id):
    return {
        "ts": time.time(),
        "robot_id": robot_id,
        "event_type": random.choice(["heartbeat","pose","battery"]),
        "lat": 37.77 + random.uniform(-0.01, 0.01),
        "lng": -122.41 + random.uniform(-0.01, 0.01),
        "battery": random.uniform(20, 100),
        "payload": {"speed": random.uniform(0, 2.5)}
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--project", default=os.getenv("GOOGLE_CLOUD_PROJECT"))
    parser.add_argument("--topic", default="robofleet-telemetry")
    parser.add_argument("--robots", type=int, default=100)
    parser.add_argument("--rate", type=int, default=5, help="events/sec per robot")
    args = parser.parse_args()

    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(args.project, args.topic)

    robots = [f"robot-{i:04d}" for i in range(args.robots)]
    print(f"Publishing to {topic_path} from {len(robots)} robots at {args.rate} eps/robot")
    while True:
        start = time.time()
        for r in robots:
            data = json.dumps(gen_event(r)).encode("utf-8")
            publisher.publish(topic_path, data=data)
        elapsed = time.time() - start
        sleep = max(0, 1/args.rate - elapsed)
        time.sleep(sleep)

if __name__ == "__main__":
    main()