classdef SkpCollatedDataset < CollatedDataset
    properties
        animal_id = '';
        slice_id = '';
        group_id = '';
    end
    methods
        % SkpCollatedDataset class constructor (inherited from CollatedDataset
        function obj = SkpCollatedDataset(animal_id,slice_id)
            % provide values for superclass constructor (CollatedDataset)
            if nargin == 0
                args{1} = 'undefined'; % uid
            else
                args{1} = [animal_id '_' slice_id];
            end
            % call superclass constructor before accessing object
            obj = obj@CollatedDataset(args{:});
            % initialize subclass properties
            obj.animal_id = animal_id;
            obj.slice_id = slice_id;
            
            % all SkpCollatedDataset objects have a common set of contents
            % specific to the SKP-SC spinal cord injury project
            obj = obj.initDataset();
        end
        
        % initialize SkpCollatedDataset object with standard skeleton
        function obj = initDataset(obj)
            % Each DataScheme has the ParxDatasets listed in parx_names.
            % The hierarchy of objects runs as follows:
            %   I. DataScheme
            %      II. ParxDataset
            %      II. Segmentation
            %          III. SegZone
            %
            % Specifically:
            %
            % DataSchemes               Segmentation        SegZone
            % ===========               ============        =======
            % MRIPixelGrid              Sectors             Ventral
            %                                               Lateral
            %                                               Dorsal
            %                           WholeSection        All
            %
            % Squares_63x               IntactvsDamaged     Intact
            %                                               Damaged
            % ECVentralIntactvsDamaged  IntactvsDamaged     Intact
            %                                               Damaged
            
            parx_names = {'GFAP_AvgOD','GFAP_AvgODThresh','GFAP_AreaFraction', ...
                'P0_AvgOD','P0_AvgODThresh','P0_AreaFraction', 'P0_IntegODThresh',...
                'GFPSet1_AvgOD','GFPSet1_AvgODThresh','GFPSet1_AreaFraction', 'GFPSet1_IntegODThresh', ...
                'MBP_AvgOD','MBP_AvgODThresh','MBP_IntegODThresh','MBP_AreaFraction','MBP_incl_mask', ...
                'Axon_AvgOD','Axon_AvgODThresh','Axon_IntegODThresh','Axon_AreaFraction','Axon_incl_mask' ...
                'GFPSet2_AvgOD','GFPSet2_AvgODThresh','GFPSet2_AreaFraction', ...
                'EC_AvgOD','EC_AvgODThresh','EC_IntegODThresh','EC_AreaFraction','EC_incl_mask' ...
                'FA','ADC','Dlong','Dtrans','TrW', ...
                'CPMG_echo10','CPMG_So','CPMG_flipangle','MWF','CPMG_SNR', ...
                'CPMG_misfit','MWF_CVstim','MWF_fixedmisfit','MRI_incl_mask', ...
                'MWF_CVvarlim','CPMG_GoF_CVvarlim','CPMG_GoF_fixedmisfit',...
                'CPMG_IntegLim_CVvarlim'};
            n_parx = numel(parx_names);
            
            % MRIPixelGrid DataScheme
            obj = obj.updateDataScheme('MRIPixelGrid');
            obj.data_schemes.('MRIPixelGrid') = obj.data_schemes.('MRIPixelGrid').updateSeg('Sectors');
            obj.data_schemes.('MRIPixelGrid').segs.('Sectors') = obj.data_schemes.('MRIPixelGrid').segs.('Sectors').updateSegZones('Ventral');
            obj.data_schemes.('MRIPixelGrid').segs.('Sectors') = obj.data_schemes.('MRIPixelGrid').segs.('Sectors').updateSegZones('Dorsal');
            obj.data_schemes.('MRIPixelGrid').segs.('Sectors') = obj.data_schemes.('MRIPixelGrid').segs.('Sectors').updateSegZones('Lateral');
            obj.data_schemes.('MRIPixelGrid') = obj.data_schemes.('MRIPixelGrid').updateSeg('WholeSection');
            obj.data_schemes.('MRIPixelGrid').segs.('WholeSection') = obj.data_schemes.('MRIPixelGrid').segs.('WholeSection').updateSegZones('All');
            
            for i=1:n_parx
                obj.data_schemes.('MRIPixelGrid') = obj.data_schemes.('MRIPixelGrid').updateParxDataset(parx_names{i});
            end
            
            % Squares_63x DataScheme
            obj = obj.updateDataScheme('Squares_63x');
            obj.data_schemes.('Squares_63x') = obj.data_schemes.('Squares_63x').updateSeg('DamagedvsIntact');
            obj.data_schemes.('Squares_63x').segs.('DamagedvsIntact') = obj.data_schemes.('Squares_63x').segs.('DamagedvsIntact').updateSegZones('Damaged');
            obj.data_schemes.('Squares_63x').segs.('DamagedvsIntact') = obj.data_schemes.('Squares_63x').segs.('DamagedvsIntact').updateSegZones('Intact');
            for i=1:n_parx
                obj.data_schemes.('Squares_63x') = obj.data_schemes.('Squares_63x').updateParxDataset(parx_names{i});
            end
            
            % ECVentralDamagedvsIntact DataScheme
            obj = obj.updateDataScheme('ECVentralDamagedvsIntact');
            obj.data_schemes.('ECVentralDamagedvsIntact') = obj.data_schemes.('ECVentralDamagedvsIntact').updateSeg('DamagedvsIntact');
            obj.data_schemes.('ECVentralDamagedvsIntact').segs.('DamagedvsIntact') = obj.data_schemes.('ECVentralDamagedvsIntact').segs.('DamagedvsIntact').updateSegZones('Damaged');
            obj.data_schemes.('ECVentralDamagedvsIntact').segs.('DamagedvsIntact') = obj.data_schemes.('ECVentralDamagedvsIntact').segs.('DamagedvsIntact').updateSegZones('Intact');
            for i=1:n_parx
                obj.data_schemes.('ECVentralDamagedvsIntact') = obj.data_schemes.('ECVentralDamagedvsIntact').updateParxDataset(parx_names{i});
            end
        end
        

        
        % print info about object contents
        function print(obj)
            disp(['animal_id = ' obj.animal_id ', ' ...
                '.slice_id = ' obj.slice_id]);
            obj.print@CollatedDataset();
        end
    end
end