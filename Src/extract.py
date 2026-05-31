import requests
import os
import logging

def download_zipped_data(url: str, zip_path: str) -> None:
    logging.info(f'Downloading data from {url}')

    response = requests.get(url)

    if response.status_code != 200:
        logging.error(f'Failed to download data from {url}. Status code: {response.status_code}')

        raise Exception(f'Failed to download data. Status code: {response.status_code}')

    if not os.path.exists(zip_path):
        os.makedirs(zip_path)

    if response.content is not None:
        logging.info(f'Saving data to {zip_path}')

        with open(f'{zip_path}/data.zip', 'wb') as f:
            f.write(response.content)

        logging.info(f'Data saved to {zip_path}')

def zip_to_csv(csv_path: str, zip_path: str) -> None:
    logging.info(f'Unzipping data from {zip_path} to {csv_path}')

    csv_path = 'Data/CSV'

    if not os.path.exists(csv_path):
        os.makedirs(csv_path)
        
        if not os.path.exists(f'{zip_path}/data.zip'):
            logging.error(f'Zip file not found in {zip_path}')

            raise Exception(f'Zip file not found in {zip_path}')

        for file in os.listdir(csv_path):
            os.remove(f'{csv_path}/{file}')

        import zipfile
        with zipfile.ZipFile(f'{zip_path}/data.zip', 'r') as zip_ref:
            zip_ref.extractall(f'{csv_path}')

    logging.info(f'Data unzipped to {csv_path}')

def delete_zip(zip_path: str) -> None:
    logging.info(f'Deleting zip file from {zip_path}')

    if os.path.exists(f'{zip_path}/data.zip'):
        os.remove(f'{zip_path}/data.zip')

    logging.info(f'Zip file deleted from {zip_path}')

def delete_non_csv_files(path: str) -> None:
    logging.info(f'Deleting non csv files from {path}')

    for file in os.listdir(path):
        if not file.endswith('.csv'):
            logging.info(f'Deleting {path}/{file}')
            os.remove(f'{path}/{file}')

    logging.info(f'Non csv files deleted from {path}')

def extract_data(url: str, zip_path: str, csv_path: str) -> None:
    logging.info(f'Initializing data extraction from {url}')

    download_zipped_data(url=url, zip_path=zip_path)
    zip_to_csv(csv_path=csv_path, zip_path=zip_path)
    delete_non_csv_files(path=csv_path + '/data_release')
    delete_zip(zip_path=zip_path)

    logging.info(f'Data extracted from {url}')

# Testes
url = 'https://files.grouplens.org/datasets/movielens/ml_belief_2024_data_release_2.zip'
zip_path = 'Data/ZIP'
csv_path = 'Data/CSV'

extract_data(url=url, zip_path=zip_path, csv_path=csv_path)