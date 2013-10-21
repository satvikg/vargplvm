function Y = svargplvmMapModalitiesHigh(balanceModalityDim, Y, modalityMappingsAll)

if nargin < 3
    modalityMappingsAll = cell(1,length(Y));
end

if sum(cell2mat(balanceModalityDim)) > 0
    maxDval = -Inf;
    % Find maximum dimensionality
    for i=1:length(Y)
        if size(Y{i},2) > maxDval
            maxDval = size(Y{i},2);
        end
    end
    
    % Do the mapping
    for i=1:length(Y)
        curD = size(Y{i},2);
        if curD < maxDval && balanceModalityDim{i}
            fprintf('# Mapping modality %d from %d to %d dimensions!\n', i, curD, maxDval)
            if isempty(modalityMappingsAll{i})
                % Fix seed for the random mapping so that it's reproducible
                curSeed = rng;
                rng(123);
                modalityMapping = rand(curD, maxDval);
                rng(curSeed);
                %--
            else
                modalityMapping = modalityMappingsAll{i};
            end
            Ytmp = zeros(size(Y{i},1), maxDval);
            for n = 1:size(Ytmp,1)
                Ytmp(n,:) = Y{i}(n,:)*modalityMapping;
            end
            Y{i} = Ytmp;
        end
    end
end