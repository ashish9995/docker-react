# So here we are defining a oontainer that has multistep process
# first : build the react app
# host the static content of the built app into the nginx server

# Here we are building two containers where the first container will build the react project with all the static and build file created and this container
# will be refered as the builder which will further refrenced in the second phase of the image creation where we will copy all these build files for the application
# ngnix server

FROM node:16-alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

#this is the second phase
#just makring FROM here will let the docker know that we are planning to start another phase in the docker file.
FROM nginx

# Here we are mentioning that as part of the second phase we want to have a nginx image that has the build folder from the previous phase.
# specifying --from= states that we want to copy from the builder phase. /app/build is the the folder that we want to copy and the destination is the
# other path which is specific to the nginx configuration.
COPY --from=builder /app/build /usr/share/nginx/html

