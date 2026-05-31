from google.cloud.storage import Client, transfer_manager
import logging

def load_data(
    bucket_name: str,
    filenames: list,
    source_directory: str = "",
    workers: int = 8
) -> None:

    storage_client = Client()
    bucket = storage_client.bucket(bucket_name)

    results = transfer_manager.upload_many_from_filenames(
        bucket=bucket,
        filenames=filenames,
        source_directory=source_directory,
        blob_name_prefix="bronze/",
        max_workers=workers,
        worker_type=transfer_manager.THREAD
    )

    for name, result in zip(filenames, results):
        # The results list is either `None` or an exception for each filename in
        # the input list, in order.

        if isinstance(result, Exception):
            logging.error(f"Failed to upload {name} due to exception: {result}")
            raise Exception(f"Failed to upload {name} due to exception: {result}")
        else:
            logging.info(f"Uploaded {name} to {bucket.name}.")

# Testes
import os

files = []
for file in os.listdir("Data/CSV/data_release"):
    files.append(f"{file}")

load_data(bucket_name="desafio-tecnico-dpt-movielens", filenames=files, source_directory="Data/CSV/data_release", workers=4)