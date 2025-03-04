services:
    app:
        build:
            context: .
            dockerfile: Dockerfile
        ports:
            - '3000:3000'
        environment:
            - NODE_ENV=production
            - MONGODB_URI=${MONGODB_URI:-mongodb://root:example@localhost:27017/mydatabase}
            - LOG_LEVEL=${LOG_LEVEL:-info}
            - PERSISTENCE=${PERSISTENCE:-true}
        depends_on:
            - mongodb

    mongodb:
        image: mongo:latest
        ports:
            - '27017:27017'
        environment:
            - MONGO_INITDB_ROOT_USERNAME=root
            - MONGO_INITDB_ROOT_PASSWORD=example
        volumes:
            - ./mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro
            - mongodb_data:/data/db
        healthcheck:
            test: ['CMD', 'mongosh', '--eval', "db.adminCommand('ping')"]
            interval: 10s
            timeout: 5s
            retries: 5
            start_period: 30s

volumes:
    mongodb_data:
        driver: local
