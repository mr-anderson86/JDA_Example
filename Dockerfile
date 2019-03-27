FROM centos:7
ENV VERSION=1.2.0
RUN yum install perl vim zip unzip -y
ADD zip_job.pl /tmp/zip_job.pl
CMD echo "OS: `cat /etc/os-release | grep PRETTY_NAME | cut -d'\"' -f2`"; \
echo "Architecture: `arch`"; \
if [[ ! -f /tmp/zip_job.pl ]]; \
then \
echo "[ERROR] file /tmp/zip_job.pl is not found"; \
exit 1; \
else \
echo "[INFO] file /tmp/zip_job.pl is there"; \
fi
